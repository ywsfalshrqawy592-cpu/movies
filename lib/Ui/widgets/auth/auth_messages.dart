import 'package:movies_app/l10n/app_localizations.dart';

import 'auth_failure.dart';
import 'auth_validators.dart';

/// Turns authentication failures and validation errors into localized text.
///
/// No provider code or account-existence detail ever reaches the UI.
class AuthMessages {
  const AuthMessages._();

  static String failure(
    AppLocalizations l10n,
    AuthFailure failure,
  ) => switch (failure.type) {
    AuthFailureType.invalidEmail => l10n.authErrorInvalidEmail,
    AuthFailureType.weakPassword => l10n.authErrorWeakPassword,
    AuthFailureType.invalidCredentials => l10n.authErrorInvalidCredentials,
    AuthFailureType.emailAlreadyInUse => l10n.authErrorEmailInUse,
    AuthFailureType.userDisabled => l10n.authErrorUserDisabled,
    AuthFailureType.tooManyRequests => l10n.authErrorTooManyRequests,
    AuthFailureType.networkError => l10n.authErrorNetwork,
    AuthFailureType.requiresRecentLogin => l10n.authErrorRequiresRecentLogin,
    AuthFailureType.operationNotAllowed => l10n.authErrorOperationNotAllowed,
    AuthFailureType.invalidActionCode => l10n.authErrorResetLinkInvalid,
    AuthFailureType.unknown => l10n.authErrorUnexpected,
  };

  static String emailError(AppLocalizations l10n, EmailValidationError error) =>
      switch (error) {
        EmailValidationError.empty => l10n.authErrorEmailRequired,
        EmailValidationError.invalidFormat => l10n.authErrorEmailInvalid,
      };

  static String passwordError(
    AppLocalizations l10n,
    PasswordValidationError error,
  ) => switch (error) {
    PasswordValidationError.empty => l10n.authErrorPasswordRequired,
    PasswordValidationError.tooShort => l10n.authErrorPasswordTooShort(
      AuthValidators.minPasswordLength,
    ),
    PasswordValidationError.missingLetter => l10n.authErrorPasswordLetter,
    PasswordValidationError.missingDigit => l10n.authErrorPasswordDigit,
  };

  static String confirmPasswordError(
    AppLocalizations l10n,
    ConfirmPasswordValidationError error,
  ) => switch (error) {
    ConfirmPasswordValidationError.empty =>
      l10n.authErrorConfirmPasswordRequired,
    ConfirmPasswordValidationError.mismatch =>
      l10n.authErrorPasswordsDoNotMatch,
  };

  static String nameError(AppLocalizations l10n, NameValidationError error) =>
      switch (error) {
        NameValidationError.empty => l10n.authErrorNameRequired,
      };

  static String phoneError(AppLocalizations l10n, PhoneValidationError error) =>
      switch (error) {
        PhoneValidationError.invalidFormat => l10n.authErrorPhoneInvalid,
      };
}
