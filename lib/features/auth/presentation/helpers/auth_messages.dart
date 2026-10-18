import 'package:movies_app/l10n/app_localizations.dart';

import '../../domain/failures/auth_failure.dart';
import '../../domain/validation/auth_validators.dart';

/// Turns domain failures and validation errors into localized messages.
///
/// Keeping the mapping in one place means no screen contains raw error text and
/// no provider detail (error code, account existence, ...) ever reaches the UI.
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
}
