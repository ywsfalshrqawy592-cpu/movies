// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'أهلاً';

  @override
  String get appTitle => 'تطبيق الأفلام';

  @override
  String get authLoginTitle => 'تسجيل الدخول';

  @override
  String get authLoginSubtitle => 'مرحبًا بعودتك';

  @override
  String get authRegisterTitle => 'إنشاء حساب';

  @override
  String get authRegisterSubtitle => 'أنشئ حسابك الخاص';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authPasswordHint => 'أدخل كلمة المرور';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get authNameLabel => 'الاسم';

  @override
  String get authNameHint => 'أدخل اسمك';

  @override
  String get authLoginButton => 'تسجيل الدخول';

  @override
  String get authRegisterButton => 'إنشاء الحساب';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authNoAccount => 'ليس لديك حساب؟';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authSignUp => 'سجّل الآن';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authShowPassword => 'إظهار كلمة المرور';

  @override
  String get authHidePassword => 'إخفاء كلمة المرور';

  @override
  String get authEmailVerificationTitle => 'تحقق من بريدك الإلكتروني';

  @override
  String authEmailVerificationSentTo(String email) {
    return 'أرسلنا رابط تحقق إلى $email. افتح الرابط ثم عد إلى هذه الشاشة.';
  }

  @override
  String get authEmailVerificationSpamHint =>
      'لم يصلك البريد؟ تحقق من مجلد الرسائل غير المرغوب فيها.';

  @override
  String get authResendVerificationEmail => 'إعادة إرسال البريد';

  @override
  String authResendVerificationEmailIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ثانية';
  }

  @override
  String get authIVerifiedMyEmail => 'لقد تحققت من بريدي';

  @override
  String get authVerificationEmailSent => 'تم إرسال بريد التحقق.';

  @override
  String get authStillNotVerified =>
      'لم يتم التحقق من بريدك بعد. افتح الرابط الذي أرسلناه ثم حاول مرة أخرى.';

  @override
  String get authEmailVerified => 'تم التحقق من بريدك الإلكتروني.';

  @override
  String get authUseAnotherAccount => 'استخدام حساب آخر';

  @override
  String get authForgotPasswordBody =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get authForgotPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get authSendResetLink => 'إرسال رابط الاستعادة';

  @override
  String get authResetLinkSent =>
      'إذا كان هناك حساب بهذا البريد الإلكتروني فقد أُرسل رابط إعادة التعيين. تحقق من صندوق الوارد.';

  @override
  String get authLogout => 'تسجيل الخروج';

  @override
  String get authLogoutConfirmBody => 'هل تريد تسجيل الخروج من هذا الحساب؟';

  @override
  String get authCancel => 'إلغاء';

  @override
  String get authDeleteAccount => 'حذف الحساب';

  @override
  String get authDeleteAccountConfirmBody =>
      'سيؤدي هذا الإجراء إلى حذف حسابك نهائيًا. أدخل كلمة المرور للمتابعة.';

  @override
  String get authDeleteAccountConfirmButton => 'حذف';

  @override
  String get authDeleteAccountSuccess => 'تم حذف حسابك.';

  @override
  String get authEditProfile => 'تعديل الملف الشخصي';

  @override
  String get authErrorEmailRequired => 'من فضلك أدخل بريدك الإلكتروني.';

  @override
  String get authErrorEmailInvalid => 'من فضلك أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get authErrorPasswordRequired => 'من فضلك أدخل كلمة المرور.';

  @override
  String authErrorPasswordTooShort(int min) {
    return 'يجب أن تتكون كلمة المرور من $min أحرف على الأقل.';
  }

  @override
  String get authErrorPasswordLetter =>
      'يجب أن تحتوي كلمة المرور على حرف واحد على الأقل.';

  @override
  String get authErrorPasswordDigit =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل.';

  @override
  String get authErrorConfirmPasswordRequired => 'من فضلك أكد كلمة المرور.';

  @override
  String get authErrorPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get authErrorNameRequired => 'من فضلك أدخل اسمك.';

  @override
  String get authErrorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authErrorEmailInUse => 'هذا البريد الإلكتروني مسجل بالفعل.';

  @override
  String get authErrorWeakPassword => 'كلمة المرور ضعيفة جدًا.';

  @override
  String get authErrorInvalidEmail => 'هذا البريد الإلكتروني غير صحيح.';

  @override
  String get authErrorTooManyRequests =>
      'محاولات كثيرة. من فضلك حاول مرة أخرى لاحقًا.';

  @override
  String get authErrorNetwork =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';

  @override
  String get authErrorUserDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get authErrorRequiresRecentLogin =>
      'من فضلك سجّل الدخول مرة أخرى للمتابعة.';

  @override
  String get authErrorOperationNotAllowed =>
      'طريقة تسجيل الدخول هذه غير متاحة حاليًا.';

  @override
  String get authErrorUnexpected => 'حدث خطأ ما. من فضلك حاول مرة أخرى.';
}
