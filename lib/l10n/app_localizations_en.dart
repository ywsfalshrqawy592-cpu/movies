// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get appTitle => 'Movies App';

  @override
  String get authLoginTitle => 'Login';

  @override
  String get authLoginSubtitle => 'Welcome back';

  @override
  String get authRegisterTitle => 'Register';

  @override
  String get authRegisterSubtitle => 'Create your account';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'Enter your email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authConfirmPasswordHint => 'Re-enter your password';

  @override
  String get authNameLabel => 'Name';

  @override
  String get authNameHint => 'Enter your name';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authRegisterButton => 'Create account';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authEmailVerificationTitle => 'Verify your email';

  @override
  String authEmailVerificationSentTo(String email) {
    return 'We sent a verification link to $email. Open the link, then come back to this screen.';
  }

  @override
  String get authEmailVerificationSpamHint =>
      'Didn\'t get the email? Check your spam folder.';

  @override
  String get authResendVerificationEmail => 'Resend email';

  @override
  String authResendVerificationEmailIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authIVerifiedMyEmail => 'I verified my email';

  @override
  String get authVerificationEmailSent => 'Verification email sent.';

  @override
  String get authStillNotVerified =>
      'Your email is not verified yet. Open the link we sent you, then try again.';

  @override
  String get authEmailVerified => 'Your email has been verified.';

  @override
  String get authUseAnotherAccount => 'Use another account';

  @override
  String get authForgotPasswordBody =>
      'Enter your email and we will send you a link to reset your password.';

  @override
  String get authForgotPasswordTitle => 'Forget Password';

  @override
  String get authSendResetLink => 'Send reset link';

  @override
  String get authResetLinkSent =>
      'If an account exists for this email, a reset link has been sent. Check your inbox.';

  @override
  String get authNewPasswordTitle => 'Set a new password';

  @override
  String authNewPasswordBody(String email) {
    return 'Choose a new password for $email.';
  }

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String get authNewPasswordButton => 'Save new password';

  @override
  String get authNewPasswordSuccess =>
      'Your password has been updated. Sign in with your new password.';

  @override
  String get authResetLinkProblemBody =>
      'This password reset link cannot be used.';

  @override
  String get authRequestNewResetLink => 'Request a new reset link';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authUpdateData => 'Update Data';

  @override
  String get authPickAvatar => 'Tap the avatar to change it';

  @override
  String get authPhoneLabel => 'Phone number (optional)';

  @override
  String get authProfileUpdated => 'Your profile has been updated.';

  @override
  String get authLogout => 'Logout';

  @override
  String get authLogoutConfirmBody =>
      'Do you want to logout from this account?';

  @override
  String get authCancel => 'Cancel';

  @override
  String get authDeleteAccount => 'Delete Account';

  @override
  String get authDeleteAccountConfirmBody =>
      'This action permanently deletes your account. Enter your password to continue.';

  @override
  String get authDeleteAccountConfirmButton => 'Delete';

  @override
  String get authDeleteAccountSuccess => 'Your account has been deleted.';

  @override
  String get authEditProfile => 'Edit profile';

  @override
  String get authErrorEmailRequired => 'Please enter your email.';

  @override
  String get authErrorEmailInvalid => 'Please enter a valid email address.';

  @override
  String get authErrorPasswordRequired => 'Please enter your password.';

  @override
  String authErrorPasswordTooShort(int min) {
    return 'Password must be at least $min characters.';
  }

  @override
  String get authErrorPasswordLetter =>
      'Password must contain at least one letter.';

  @override
  String get authErrorPasswordDigit =>
      'Password must contain at least one number.';

  @override
  String get authErrorConfirmPasswordRequired =>
      'Please confirm your password.';

  @override
  String get authErrorPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String get authErrorNameRequired => 'Please enter your name.';

  @override
  String get authErrorPhoneInvalid => 'Please enter a valid phone number.';

  @override
  String get authErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authErrorEmailInUse => 'This email is already registered.';

  @override
  String get authErrorWeakPassword => 'This password is too weak.';

  @override
  String get authErrorInvalidEmail => 'This email address is not valid.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authErrorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get authErrorUserDisabled => 'This account has been disabled.';

  @override
  String get authErrorRequiresRecentLogin =>
      'Please sign in again to continue.';

  @override
  String get authErrorOperationNotAllowed =>
      'This sign-in method is not available right now.';

  @override
  String get authErrorResetLinkInvalid =>
      'This reset link is invalid or has expired. Please request a new one.';

  @override
  String get authErrorUnexpected => 'Something went wrong. Please try again.';
}
