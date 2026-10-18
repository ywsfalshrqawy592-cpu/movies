# نظام المصادقة (Firebase Authentication)

هذا المستند يشرح نظام المصادقة الكامل الذي أُضيف إلى المشروع: المحتوى، المعمارية،
التدفقات، خطوات تشغيل Firebase، طريقة التشغيل والاختبار، والقيود المعروفة.

## 1. نظرة عامة

النظام يغطي:

- **تسجيل الدخول** بالبريد الإلكتروني وكلمة المرور.
- **إنشاء حساب** بالاسم والبريد وكلمة المرور.
- **تأكيد البريد الإلكتروني** (إلزامي قبل الوصول للشاشة الرئيسية).
- **نسيت كلمة المرور** عبر إرسال رابط إعادة التعيين من Firebase.
- **تسجيل الخروج** مع تأكيد.
- **حذف الحساب** بعد إعادة التحقق من كلمة المرور.
- **حالة جلسة مركزية** واحدة (`AuthCubit`) تتحكم في التنقل بين شاشات المصادقة
  والشاشة الرئيسية.

القرارات الأمنية المطبقة:

- لا يتم إظهار ما إذا كان البريد مسجلًا أم لا (رسالة إعادة التعيين محايدة،
  وأخطاء Firebase `user-not-found` / `wrong-password` تُدمج في رسالة واحدة).
- لا تُخزَّن كلمات المرور ولا تُسجَّل في أي logs.
- لا توجد أي مفاتيح إدارية أو أسرار في التطبيق (فقط مفاتيح الويب/التطبيق العامة).
- منع الطلبات المكررة: كل زر يُعطَّل ويُعرض فيه مؤشر تحميل أثناء الطلب
  (وكل cubit يتجاهل الطلب إذا كان هناك طلب جارٍ).
- الحذف يتطلب إعادة التحقق من كلمة المرور أولًا (re-authentication).

## 2. المعمارية

المشروع لا يستخدم حاوية DI، فمكوّن التركيب (composition root) هو
`RepositoryProvider` + `BlocProvider` كما في `LanguageCubit` الموجود:

```
lib/features/auth/
├── auth_scope.dart                     # ربط التبعيات (RepositoryProvider + BlocProvider)
├── domain/                             # لا تعرف شيئًا عن Firebase
│   ├── entities/app_user.dart          # مستخدم التطبيق (بدون أنواع Firebase)
│   ├── failures/auth_failure.dart      # أنواع الأخطاء (enum + cause اختياري)
│   ├── repositories/auth_repository.dart
│   ├── usecases/                       # 9 حالات استخدام صغيرة (SignIn, Register, ...)
│   └── validation/auth_validators.dart # سياسة كلمة المرور + البريد + الاسم
├── data/                               # كل تفاصيل Firebase هنا
│   ├── data_sources/firebase_auth_data_source.dart
│   ├── mappers/auth_error_mapper.dart  # FirebaseAuthException → AuthFailure
│   ├── mappers/firebase_user_mapper.dart
│   └── repositories/firebase_auth_repository.dart
└── presentation/
    ├── cubits/                         # 6 cubits (auth, login, register, forgot_password,
    │                                   #          email_verification, delete_account)
    ├── helpers/auth_messages.dart      # AuthFailure → نص مترجم
    ├── screens/                        # AuthGate, Login, Register, EmailVerification,
    │                                   # AuthLoading
    └── widgets/                        # عناصر مشتركة لشاشات المصادقة
```

### المصادر المشتركة في بقية المشروع

- `lib/main.dart`: `Firebase.initializeApp` + تسجيل المسارات الجديدة.
- `lib/utils/app_routes.dart`: أسماء المسارات (`registerRouteName`,
  `forgotPasswordRouteName`, `updateProfileRouteName`).
- `lib/Ui/screens/reset_password/reset_password_screen.dart`: وُصل بـ `ForgotPasswordCubit`
  (نفس تصميم الفريق، بدون تكرار شاشة).
- `lib/Ui/screens/update_profile/update_profile_screen.dart`: زر إعادة تعيين كلمة المرور
  وزر حذف الحساب (كانا TODO) أُوصلا.
- `lib/Ui/screens/home/home_screen.dart`: أيقونتا الملف الشخصي وتسجيل الخروج.
- `lib/Ui/widgets/custom_elevated_botton.dart`: أُضيفت `isLoading` و
  `progressIndicatorColor` و`onPressed` صار يقبل `null` (توافق للخلف محفوظ).
- `lib/Ui/widgets/custom_text_field.dart`: أُضيفت `textInputAction` و
  `onFieldSubmitted` و`autofocus`.
- `lib/l10n/app_en.arb` + `app_ar.arb`: مفاتيح المصادقة (~60 مفتاحًا)، مع تصحيح
  خطأ JSON كان يمنع `flutter pub get` في ملف `app_ar.arb`.

## 3. التدفقات

### 3.1 التنقل المركزي — `AuthGate`

`AppRoutes.homeRouteName` يشير إلى `AuthGate`، وهو الجهة الوحيدة التي تقرر الشاشة:

| حالة الجلسة            | الشاشة المعروضة          |
| ---------------------- | ------------------------ |
| `unknown`              | `AuthLoadingScreen`      |
| `unauthenticated`      | `LoginScreen`            |
| `emailNotVerified`     | `EmailVerificationScreen`|
| `authenticated`        | `HomeScreen`             |

عند انتهاء الجلسة (خروج، أو إبطال من مزود الهوية، أو حذف الحساب) يستمع
`AuthGate` للتغيير وينفذ `popUntil(isFirst)` حتى لا تبقى أي شاشة محمية ظاهرة
فوق شاشة الدخول.

### 3.2 تسجيل الدخول

1. الشاشة تتحقق محليًا من صيغة البريد ومن أن كلمة المرور غير فارغة.
2. `LoginCubit` يستدعي `SignInWithEmail` → بيانات Firebase.
3. `AuthCubit` يستقبل المستخدم من stream الجلسة ويحدد الوجهة:
   - بريد مؤكد → الشاشة الرئيسية.
   - بريد غير مؤكد → شاشة تأكيد البريد.

### 3.3 إنشاء الحساب

1. التحقق من الاسم والبريد وسياسة كلمة المرور (8 أحرف على الأقل + حرف + رقم)
   وتطابق التأكيد.
2. `RegisterCubit` ينشئ الحساب ويطلب إرسال رسالة التأكيد.
3. الشاشة تُغلق (`popUntil(isFirst)`) والبوابة تعرض شاشة التأكيد.

### 3.4 تأكيد البريد الإلكتروني

- زر "أرسل مرة أخرى" عليه عدّاد تنازلي (60 ثانية) لمنع الإرسال المتكرر.
- زر "تحققت من بريدي" يستدعي `AuthCubit.refreshUser()` الذي يعيد تحميل الملف من
  المزود ويعيد القيمة `true` / `false` / `null` (تعذر الاتصال)، فلا يمكن تأكيد
  البريد محليًا أبدًا.

### 3.5 نسيت كلمة المرور

- رسالة النجاح محايدة: "إذا كان هناك حساب بهذا البريد، فقد أُرسل رابط إعادة
  التعيين" — حتى لا تُستغل الشاشة لمعرفة الحسابات المسجلة.

### 3.6 تسجيل الخروج وحذف الحساب

- الخروج يمر عبر `AuthCubit.signOut()` ثم stream الجلسة يتولى التنقل.
- الحذف: `DeleteAccountDialog` يطلب كلمة المرور، ثم
  `DeleteAccountCubit` ينفذ `reauthenticateWithPassword` قبل `deleteAccount`.
  النجاح يُغلق كل الشاشات ويعرض رسالة تأكيد الحذف على شاشة الدخول.

## 4. إعداد Firebase

### 4.1 جاهز في المستودع

- `lib/firebase_options.dart` يحتوي قيم Android / iOS / macOS المأخوذة من
  `android/app/google-services.json` و`ios/Runner/GoogleService-Info.plist`
  و`macos/Runner/GoogleService-Info.plist` (مشروع `movies-app-3cb31`).
- `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` في
  `lib/main.dart`.

### 4.2 خطوات يدوية مطلوبة (لم تُنفَّذ من بيئة التطوير الحالية)

الحساب المسجل في Firebase CLI (`mosheta611@gmail.com`) لا يملك صلاحية على المشروع
(كل أوامر `firebase` و`flutterfire` تُرجع `403 PERMISSION_DENIED`)، لذلك يجب أن
ينفذ شخص يملك الصلاحية ما يلي:

1. **تفعيل مصادقة Firebase نفسها ثم مزود الدخول بالبريد وكلمة المرور:**
   Firebase Console → Authentication → **Get started** (هذه الخطوة مطلوبة أولًا
   لأن خدمة Authentication غير مهيأة على المشروع إطلاقًا — انظر ملاحظة الفحص
   الحيّ أدناه) → Sign-in method → Email/Password → Enable.
   (بدون هذه الخطوة ستفشل كل عمليات الدخول برسالة مزود، وبعد التهيئة فقط
   يظهر تبويب Sign-in method.)
   - ملاحظة الفحص الحيّ (2026-10-18): نداءا `accounts:signInWithPassword` و
     `accounts:createAuthUri` على مشروع `movies-app-3cb31` يرجعان
     `CONFIGURATION_NOT_FOUND`، أي أن خدمة Authentication لم تُفعَّل بعد على
     المشروع (وليس فقط مزود البريد). التطبيق يعرض في هذه الحالة رسالة
     "This sign-in method is not available right now." بدل أي خطأ تقني.
2. **إضافة النطاقات المصرح بها** إذا سيعمل التطبيق على الويب:
   Authentication → Settings → Authorized domains.
3. **توليد قيم Web / Windows / Linux** (مفقودة حاليًا):
   ```
   flutterfire configure --project=movies-app-3cb31 --platforms=android,ios,macos,web,windows
   ```
   ثم استبدال `lib/firebase_options.dart` الناتج. حاليًا `DefaultFirebaseOptions`
   تُطلق `UnsupportedError` على Web / Windows / Linux / Fuchsia برسالة واضحة.
4. عند تغيير اسم الحزمة أو الـ bundle، تحديث `google-services.json` و
   `GoogleService-Info.plist` وإعادة توليد `firebase_options.dart`.

### 4.3 ما لم يُنفَّذ أيضًا

- لا يوجد تخزين لملف المستخدم (الاسم/الهاتف/الصورة) في قاعدة بيانات: الشاشة
  الرئيسية وشاشة الملف الشخصي تعرضان البيانات من Firebase Auth فقط. حفظ الاسم
  والصورة يحتاج قرارًا (Firestore أو Realtime Database) خارج نطاق المصادقة.

## 5. النصوص والترجمة (l10n)

- كل نصوص المصادقة في `lib/l10n/app_en.arb` و`lib/l10n/app_ar.arb` بمفاتيح تبدأ
  بـ `auth` (مثل `authLoginTitle`, `authErrorPasswordRequired`, ...).
- بعد أي تعديل على ملفات ARB:
  ```
  flutter gen-l10n
  ```
  (لا يتم تعديل ملفات `app_localizations*.dart` يدويًا.)
- التصميم يدعم العربية و RTL تلقائيًا لأن `MaterialApp` يستخدم `LanguageCubit`
  الموجود، والنصوص كلها من ملفات ARB.

## 6. الاختبارات

| الملف | التغطية |
| ----- | ------- |
| `test/features/auth/domain/auth_validators_test.dart` | سياسة كلمة المرور/البريد/التأكيد |
| `test/features/auth/data/auth_error_mapper_test.dart` | تحويل أخطاء Firebase إلى `AuthFailure` |
| `test/features/auth/data/firebase_auth_repository_test.dart` | المستودع مع مصدر بيانات وهمي |
| `test/features/auth/presentation/cubits/*_test.dart` | 6 cubits (حالات النجاح والفشل والتحميل) |
| `test/features/auth/presentation/screens/*_test.dart` | 4 شاشات (رسائل التحقق، التحميل، منع الضغط المزدوج) |
| `test/features/auth/presentation/helpers/auth_messages_test.dart` | نصوص الرسائل من الترجمة المولدة |
| `test/features/auth/integration/auth_flow_test.dart` | التدفق الكامل: جلسة، دخول، تأكيد، خروج، حذف، عربية/RTL |
| `test/widget_test.dart` | فتح التطبيق كاملًا على مستودع وهمي |

- الاختبارات تستهلك ملفات fake (`FakeAuthRepository`,
  `FakeFirebaseAuthDataSource`) ولا تتصل بـ Firebase إطلاقًا، ولذلك تعمل بدون
  مشروع أو emulator.
- الأوامر:
  ```
  flutter pub get
  flutter gen-l10n        # فقط بعد تعديل ملفات ARB
  dart format .
  flutter analyze
  flutter test
  ```
- للتشغيل اليدوي على جهاز/محاكي حقيقي (يحتاج مشروع Firebase مُعدًّا كما في 4.2):
  ```
  flutter run -d <device-id>
  ```

## 7. القيود والحالات غير المكتملة

1. **Web / Windows / Linux غير مدعومة** حاليًا لأن قيم `apiKey` الخاصة بالويب
   غير متاحة في المستودع، ولأن حساب Firebase CLI الحالي لا يملك صلاحية على
   المشروع. الحل موثق في 4.2 (بند 3).
2. **لا تخزين لبيانات الملف الشخصي** (اسم/هاتف/صورة): زر "Update Data" في
   `update_profile_screen.dart` ما زال `TODO` لأنه يحتاج قاعدة بيانات لم تُحدد بعد.
   أما "Reset Password" و"Delete Account" في نفس الشاشة فقد أُوصلا بالمصادقة.
3. **اختبار التكامل مع Firebase emulator لم يُنفَّذ**: كل الاختبارات الحالية تعمل
   على fake، والتحقق اليدوي على جهاز حقيقي يحتاج تنفيذ خطوات 4.2 أولًا.
4. **تنبيهات `flutter analyze` الأربعة** الباقية في ملفات الفريق موجودة قبل هذا
   العمل ولا علاقة لها بالمصادقة:
   - اسم الملف `onBoarding_tabs.dart`.
   - `withOpacity` المهجورة في `update_profile_screen.dart:200`.
   - اسم المتغير `KeybordTtype` في `custom_text_field.dart:56` (متروك كما هو
     حفاظًا على التوافق مع كود الفريق).
   - `import 'dart:ui'` غير الضروري في `app_colors.dart`.
5. **مجلد `temp/`** غير المتعقَّب في git يحتوي ملفات حزم pub مؤقتة، وليس جزءًا
   من هذا العمل ولا يجب إضافته للـ commit.

## 8. خطوات يدوية للمراجعة قبل الدمج

- [ ] تفعيل Email/Password في Firebase Console (بند 4.2.1).
- [ ] تشغيل `flutterfire configure` لحساب يملك الصلاحية إذا كان الويب مطلوبًا.
- [ ] تجربة يدوية على Android: تسجيل حساب جديد → تأكيد البريد → دخول → خروج →
      نسيت كلمة المرور → حذف الحساب.
- [ ] مراجعة مفاتيح الترجمة الجديدة في `app_en.arb` / `app_ar.arb`.



