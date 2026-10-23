/// Validation errors of the email field.
enum EmailValidationError { empty, invalidFormat }

/// Validation errors of the password field.
enum PasswordValidationError { empty, tooShort, missingLetter, missingDigit }

/// Validation errors of the "confirm password" field.
enum ConfirmPasswordValidationError { empty, mismatch }

/// Validation errors of the name field.
enum NameValidationError { empty }

/// Validation errors of the phone field.
enum PhoneValidationError { invalidFormat }

/// Validation rules shared by the authentication and profile forms.
///
/// They are plain Dart helpers so every screen applies the same rules. The
/// provider remains the final authority on credentials.
class AuthValidators {
  const AuthValidators._();

  static const int minPasswordLength = 8;
  static const int _maxEmailLength = 254;

  static final RegExp _emailRegExp = RegExp(
    r"^[\w.!#$%&'*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$",
  );
  static final RegExp _digitRegExp = RegExp(r'\d');
  static final RegExp _letterRegExp = RegExp(r'[A-Za-z]');
  static final RegExp _phoneCharactersRegExp = RegExp(r'^\+?[0-9\s-]+$');

  /// Removes unnecessary spaces and unifies the letter case of an email.
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

  /// Phone is optional on the profile screen. When provided it accepts digits,
  /// spaces, dashes and an optional leading `+`, with 8 to 15 digits.
  static PhoneValidationError? validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null;
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (!_phoneCharactersRegExp.hasMatch(phone) ||
        digits.length < 8 ||
        digits.length > 15) {
      return PhoneValidationError.invalidFormat;
    }
    return null;
  }
}
