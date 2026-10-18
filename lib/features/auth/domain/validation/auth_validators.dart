/// Validation errors of the email field.
enum EmailValidationError { empty, invalidFormat }

/// Validation errors of the password field.
enum PasswordValidationError { empty, tooShort, missingLetter, missingDigit }

/// Validation errors of the "confirm password" field.
enum ConfirmPasswordValidationError { empty, mismatch }

/// Validation errors of the name field.
enum NameValidationError { empty }

/// Pure validation rules shared by the authentication forms.
///
/// The rules live in the domain layer so they can be unit tested without
/// Flutter and reused by every screen. Validation in the app is a UX helper
/// only: the real enforcement happens on the provider side.
class AuthValidators {
  const AuthValidators._();

  /// Minimum number of characters accepted for a password.
  static const int minPasswordLength = 8;

  /// Length of the local part of an email address, used as a cheap sanity
  /// check before running the regular expression.
  static const int _maxEmailLength = 254;

  static final RegExp _emailRegExp = RegExp(
    r"^[\w.!#$%&'*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$",
  );

  static final RegExp _digitRegExp = RegExp(r'\d');

  static final RegExp _letterRegExp = RegExp(r'[A-Za-z]');

  /// Removes unnecessary spaces and unifies the letter case of an email.
  ///
  /// Firebase Authentication compares emails case-insensitively, normalizing
  /// them here keeps the data consistent between screens.
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  static EmailValidationError? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return EmailValidationError.empty;
    if (email.length > _maxEmailLength || !_emailRegExp.hasMatch(email)) {
      return EmailValidationError.invalidFormat;
    }
    return null;
  }

  static PasswordValidationError? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return PasswordValidationError.empty;
    if (password.length < minPasswordLength) {
      return PasswordValidationError.tooShort;
    }
    if (!_letterRegExp.hasMatch(password)) {
      return PasswordValidationError.missingLetter;
    }
    if (!_digitRegExp.hasMatch(password)) {
      return PasswordValidationError.missingDigit;
    }
    return null;
  }

  static ConfirmPasswordValidationError? validateConfirmPassword(
    String? value,
    String password,
  ) {
    final confirmation = value ?? '';
    if (confirmation.isEmpty) return ConfirmPasswordValidationError.empty;
    if (confirmation != password) {
      return ConfirmPasswordValidationError.mismatch;
    }
    return null;
  }

  static NameValidationError? validateName(String? value) {
    if ((value ?? '').trim().isEmpty) return NameValidationError.empty;
    return null;
  }
}
