# نظام المصادقة (Firebase Authentication)

هذا المستند يشرح نظام المصادقة في المشروع: البنية، التدفقات، خطوات تشغيل
Firebase، طريقة الاختبار، والقيود المعروفة.

## 1. نظرة عامة

النظام يغطي:

- **تسجيل الدخول** بالبريد الإلكتروني وكلمة المرور.
- **إنشاء حساب** بالاسم والبريد وكلمة المرور.
- **تأكيد البريد الإلكتروني** (إلزامي قبل الوصول للشاشة الرئيسية).
- **نسيت كلمة المرور**: إرسال رابط إعادة التعيين، ثم شاشة لتعيين كلمة مرور
  جديدة من رمز الرابط (`oobCode`).
- **تعديل الملف الشخصي**: الاسم والصورة الرمزية والهاتف.
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

## 2. البنية

تمت مواءمة المصادقة مع بقية المشروع: لا توجد طبقات `domain` / `data` /
`usecases` / `repositories`. المشروع يستخدم `flutter_bloc` مباشرة، ومكوّن
التركيب هو `AuthScope` كما في `LanguageCubit` داخل `main.dart`.

```
lib/Ui/
├── auth/
│   ├── auth_scope.dart                  # يوفّر AuthCubit (وخدمة Firebase)
│   ├── auth_service.dart                # كل نداءات FirebaseAuth وتحويل الأخطاء
│   ├── auth_failure.dart                # أنواع الأخطاء + تحويل أكواد Firebase
│   ├── auth_user.dart                   # نموذج المستخدم المعروض في الواجهة
│   ├── auth_validators.dart             # البريد وكلمة المرور والاسم والهاتف
│   ├── auth_messages.dart               # تحويل الأخطاء إلى نصوص مترجمة
│   └── cubits/
│       ├── auth_cubit.dart              # الجلسة + service للشاشات
│       ├── login_cubit.dart
│       ├── register_cubit.dart
│       ├── forgot_password_cubit.dart
│       ├── new_password_cubit.dart
│       ├── email_verification_cubit.dart
│       ├── update_profile_cubit.dart
│       └── delete_account_cubit.dart
├── screens/
│   ├── auth/                            # AuthGate, Login, Register,
│   │                                    # EmailVerification, NewPassword, Loading
│   ├── reset_password/                  # طلب رابط إعادة التعيين
│   └── update_profile/                  # تعديل بيانات الملف الشخصي
└── widgets/auth/                        # عناصر مشتركة لشاشات المصادقة
```

- `AuthService` هو المكان الوحيد الذي يعرف أنواع Firebase وأكواد أخطائه.
  الـ cubits تستدعيه مباشرة، والحالات (`State`) معرّفة في نفس ملف الـ cubit.
- `AuthCubit` يعرض `service` للشاشات، فكل شاشة تنشئ الـ cubit الخاص بها من
  خلال `context.read<AuthCubit>().service`.
- `AuthScope` يقبل `service` اختياريًا حتى تستطيع اختبارات الـ widget استخدام
  خدمة وهمية بدون مشروع Firebase.
- لا توجد تبعيات جديدة أُضيفت لهذا العمل.

### المصادر المشتركة في بقية المشروع

- `lib/main.dart`: `Firebase.initializeApp` + تسجيل المسارات الجديدة، بما فيها
  مسار `new_password_screen` الذي يستقبل `oobCode` من نوع `String`.
- `lib/utils/app_routes.dart`: أسماء المسارات (`registerRouteName`,
  `forgotPasswordRouteName`, `newPasswordRouteName`, `updateProfileRouteName`).
- `lib/Ui/screens/reset_password/reset_password_screen.dart`: طلب رابط إعادة
  التعيين عبر `ForgotPasswordCubit`.
- `lib/Ui/screens/update_profile/update_profile_screen.dart`: تعديل البيانات،
  وإعادة تعيين كلمة المرور، وحذف الحساب.
- `lib/Ui/screens/home/home_screen.dart`: أيقونتا الملف الشخصي وتسجيل الخروج.
- `lib/utils/app_prefs.dart`: تخزين رقم الهاتف محليًا (`profile_phone`).
- `lib/l10n/app_en.arb` + `app_ar.arb`: نصوص المصادقة والملف الشخصي، مع تصحيح
  خطأ JSON كان يمنع `flutter pub get` في ملف `app_ar.arb`.
- `lib/Ui/widgets/custom_elevated_botton.dart` و`custom_text_field.dart`:
  دعم حالة التحميل و`textInputAction` / `onFieldSubmitted` المطلوبة للشاشات.

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
2. `LoginCubit` يستدعي `AuthService.signInWithEmail`.
3. `AuthCubit` يستقبل المستخدم من stream الجلسة ويحدد الوجهة:
   - بريد مؤكد → الشاشة الرئيسية.
   - بريد غير مؤكد → شاشة تأكيد البريد.

### 3.3 إنشاء الحساب

1. التحقق من الاسم والبريد وسياسة كلمة المرور (8 أحرف على الأقل + حرف + رقم)
   وتطابق التأكيد.
2. `RegisterCubit` ينشئ الحساب، ويحفظ الاسم في ملف Firebase، ويطلب إرسال رسالة
   التأكيد.
3. الشاشة تُغلق (`popUntil(isFirst)`) والبوابة تعرض شاشة التأكيد.

### 3.4 تأكيد البريد الإلكتروني

- زر "أرسل مرة أخرى" عليه عدّاد تنازلي (60 ثانية) لمنع الإرسال المتكرر.
- زر "تحققت من بريدي" يستدعي `AuthCubit.refreshUser()` الذي يعيد تحميل الملف من
  المزود ويعيد القيمة `true` / `false` / `null` (تعذر الاتصال)، فلا يمكن تأكيد
  البريد محليًا أبدًا.

### 3.5 نسيت كلمة المرور وتعيين كلمة مرور جديدة

طلب الرابط:

1. `ResetPasswordScreen` تتحقق من صيغة البريد محليًا.
2. `ForgotPasswordCubit` يستدعي `AuthService.sendPasswordResetEmail`.
3. رسالة النجاح محايدة: "إذا كان هناك حساب بهذا البريد، فقد أُرسل رابط إعادة
   التعيين" — حتى لا تُستغل الشاشة لمعرفة الحسابات المسجلة.
4. أخطاء الإرسال (شبكة، طلبات كثيرة، مزود غير مفعّل) تظهر برسالة مترجمة، ويمكن
   إعادة المحاولة.

تعيين كلمة المرور:

1. يصل رمز الرابط (`oobCode`) إلى `NewPasswordScreen` عبر
   `AppRoutes.newPasswordRouteName`.
2. `NewPasswordCubit` يتحقق من الرمز بـ `verifyPasswordResetCode` قبل إظهار
   النموذج. الرمز المنتهي أو المستخدم أو غير الصالح يعرض رسالة واضحة وزر
   "طلب رابط جديد" بدون نموذج.
3. بعد التحقق، يظهر البريد المرتبط وحقلا كلمة المرور الجديدة وتأكيدها، مع نفس
   سياسة كلمة المرور المستخدمة في التسجيل.
4. عند الحفظ يستدعي `confirmPasswordReset`، ثم يعرض رسالة نجاح وزر العودة لتسجيل
   الدخول.
5. فشل الحفظ (مثل انقطاع الشبكة) يبقي النموذج ظاهرًا مع رسالة خطأ قابلة لإعادة
   المحاولة، ولا يعرض الرمز كمنتهٍ.

> **تحديد مهم:** رابط البريد يستخدم صفحة Firebase المستضافة افتراضيًا. شاشة
> `NewPasswordScreen` جاهزة لاستقبال `oobCode`، لكن فتحها تلقائيًا من البريد
> يحتاج ضبط Action link / deep link في Firebase Console وإعداد Android App
> Links وiOS Universal Links. هذا الإعداد لم يُنفَّذ في هذه البيئة، لذلك الرابط
> الحالي يفتح صفحة Firebase في المتصفح.

### 3.6 تعديل بيانات الملف الشخصي

1. الشاشة تُعبَّأ بالاسم والصورة من ملف Firebase، ورقم الهاتف من `AppPrefs`.
2. التحقق المحلي من الاسم (غير فارغ) والهاتف (اختياري، ولكن إذا أُدخل يجب أن
   يكون بصيغة صحيحة).
3. اختيار صورة من الصور المرفقة داخل `assets/images`.
4. `UpdateProfileCubit` يستدعي `updateDisplayName` و`updatePhotoURL`، ثم يحفظ
   الهاتف محليًا، ويعرض رسالة نجاح.
5. أثناء الحفظ يظهر مؤشر تحميل ويُمنع الضغط المزدوج. أخطاء Firebase تظهر
   برسالة مترجمة مع إبقاء البيانات في الحقول.

قيود التخزين:

- Firebase Auth لا يوفّر حقل هاتف في الملف الشخصي، لذلك الهاتف محلي على الجهاز
  فقط (`profile_phone`) ولا يُزامَن بين الأجهزة.
- الصورة تُخزَّن كمسار أصل مرفق (`assets/images/avatarN.png`) في `photoURL`،
  وليست صورة مرفوعة إلى تخزين سحابي.
- لا توجد قاعدة بيانات (Firestore/Realtime Database) لهذا العمل.

### 3.7 تسجيل الخروج وحذف الحساب

- الخروج يمر عبر `AuthCubit.signOut()` ثم stream الجلسة يتولى التنقل.
- الحذف: `DeleteAccountDialog` يطلب كلمة المرور، ثم `DeleteAccountCubit` ينفذ
  `reauthenticateWithPassword` قبل `deleteAccount`. النجاح يُغلق كل الشاشات
  ويعرض رسالة تأكيد الحذف على شاشة الدخول.

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
   - إعادة فحص على محاكي Android (2026-10-20): Firebase يعيد الخطأ داخل
     `internal-error` مع رسالة `CONFIGURATION_NOT_FOUND`، وتمت معالجة هذه
     الحالة خصوصًا في `authFailureTypeFromCode` كي تظهر الرسالة الصحيحة بدل
     "Something went wrong".
2. **إضافة النطاقات المصرح بها** إذا سيعمل التطبيق على الويب:
   Authentication → Settings → Authorized domains.
3. **ضبط Action link / deep link** إذا أردنا أن يفتح رابط البريد شاشة
   `NewPasswordScreen` داخل التطبيق بدل صفحة Firebase المستضافة. يتطلب ذلك
   Custom action URL في Firebase Console، بالإضافة إلى Android App Links
   وiOS Universal Links، ثم تمرير `oobCode` إلى المسار
   `AppRoutes.newPasswordRouteName`.
4. **توليد قيم Web / Windows / Linux** (مفقودة حاليًا):
   ```
   flutterfire configure --project=movies-app-3cb31 --platforms=android,ios,macos,web,windows
   ```
   ثم استبدال `lib/firebase_options.dart` الناتج. حاليًا `DefaultFirebaseOptions`
   تُطلق `UnsupportedError` على Web / Windows / Linux / Fuchsia برسالة واضحة.
5. عند تغيير اسم الحزمة أو الـ bundle، تحديث `google-services.json` و
   `GoogleService-Info.plist` وإعادة توليد `firebase_options.dart`.

### 4.3 ملاحظات التخزين

- الاسم والصورة الرمزية يُحفظان في ملف Firebase Auth فقط.
- الهاتف محلي في `SharedPreferences` عبر `AppPrefs`، ولا توجد قاعدة بيانات
  مركزية للملف الشخصي. أي مزامنة بين الأجهزة تحتاج قرارًا (Firestore أو
  Realtime Database) خارج نطاق هذا العمل.

## 5. النصوص والترجمة (l10n)

- كل نصوص المصادقة في `lib/l10n/app_en.arb` و`lib/l10n/app_ar.arb` بمفاتيح
  تبدأ بـ `auth` (مثل `authLoginTitle`, `authErrorPasswordRequired`,
  `authNewPasswordTitle`, `authProfileUpdated`, ...).
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
| `test/features/auth/domain/auth_validators_test.dart` | سياسة البريد وكلمة المرور والاسم والهاتف |
| `test/features/auth/data/auth_failure_test.dart` | تحويل أكواد Firebase إلى `AuthFailure` وعدم كشف وجود الحساب |
| `test/features/auth/presentation/cubits/*_test.dart` | 8 cubits (الجلسة، الدخول، التسجيل، نسيت كلمة المرور، كلمة المرور الجديدة، تأكيد البريد، تعديل الملف، حذف الحساب) |
| `test/features/auth/presentation/screens/*_test.dart` | 6 شاشات، بما فيها تعديل الملف وكلمة المرور الجديدة |
| `test/features/auth/presentation/helpers/auth_messages_test.dart` | نصوص الرسائل من الترجمة المولدة |
| `test/features/auth/integration/auth_flow_test.dart` | التدفق الكامل: جلسة، دخول، تأكيد، خروج، حذف، عربية/RTL |
| `test/widget_test.dart` | فتح التطبيق كاملًا على خدمة وهمية |

- الاختبارات تستهلك `FakeAuthService` الموجود في
  `test/features/auth/fakes/fake_auth_service.dart` ولا تتصل بـ Firebase
  إطلاقًا، ولذلك تعمل بدون مشروع أو emulator.
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

آخر نتيجة محلية: `flutter test` نجح بالكامل (121 اختبارًا)، و`flutter analyze`
لا يعرض إلا 3 ملاحظات معلوماتية سابقة في ملفات الفريق.

## 7. القيود والحالات غير المكتملة

1. **Web / Windows / Linux غير مدعومة** حاليًا لأن قيم `apiKey` الخاصة بالويب
   غير متاحة في المستودع، ولأن حساب Firebase CLI الحالي لا يملك صلاحية على
   المشروع. الحل موثق في 4.2 (بند 4).
2. **فتح رابط إعادة التعيين داخل التطبيق غير مُفعَّل**: رابط البريد يفتح صفحة
   Firebase المستضافة. شاشة `NewPasswordScreen` ومسارها جاهزان لرمز `oobCode`،
   لكن deep link / Action link لم يُضبط. راجع 4.2 (بند 3).
3. **الهاتف محلي فقط** ولا تتم مزامنته، ولا يوجد تخزين سحابي للملف الشخصي.
4. **اختبار Firebase الحقيقي والبريد والجهاز لم يُنفَّذ**: خدمة Authentication
   غير مفعّلة على المشروع (`CONFIGURATION_NOT_FOUND`)، ولا تتوفر صلاحية Firebase
   Console أو صندوق بريد أو جهاز/محاكي. كل الاختبارات أعلاه تعمل على fakes.
5. **ملاحظات `flutter analyze` الثلاث** موجودة قبل هذا العمل ولا علاقة لها
   بالمصادقة:
   - اسم الملف `onBoarding_tabs.dart`.
   - اسم المتغير `KeybordTtype` في `custom_text_field.dart`.
   - `import 'dart:ui'` غير الضروري في `app_colors.dart`.

## 8. خطوات يدوية للمراجعة قبل الدمج

- [ ] تفعيل Email/Password في Firebase Console (بند 4.2.1).
- [ ] تجربة يدوية على Android: تسجيل حساب جديد → تأكيد البريد → دخول → تعديل
      الملف الشخصي → خروج → نسيت كلمة المرور → فتح الرابط → كلمة مرور جديدة →
      دخول بالكلمة الجديدة → حذف الحساب.
- [ ] اختبار رابط منتهٍ أو مستخدم مرة أخرى، وفشل الشبكة أثناء إرسال الرابط
      وأثناء حفظ كلمة المرور الجديدة.
- [ ] ضبط deep link / Action link إذا كان مطلوبًا فتح شاشة التطبيق من البريد.
- [ ] مراجعة مفاتيح الترجمة الجديدة في `app_en.arb` / `app_ar.arb`.
