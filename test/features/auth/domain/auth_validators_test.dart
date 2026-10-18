import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/validation/auth_validators.dart';

void main() {
  group('AuthValidators.normalizeEmail', () {
    test('removes surrounding spaces and lowercases the address', () {
      expect(
        AuthValidators.normalizeEmail('  User@Movies.App  '),
        'user@movies.app',
      );
    });
  });

  group('AuthValidators.validateEmail', () {
    test('reports an empty field', () {
      expect(AuthValidators.validateEmail('   '), EmailValidationError.empty);
      expect(AuthValidators.validateEmail(null), EmailValidationError.empty);
    });

    test('accepts valid addresses', () {
      expect(AuthValidators.validateEmail('user@movies.app'), isNull);
      expect(
        AuthValidators.validateEmail('first.last+tag@sub.domain.co'),
        isNull,
      );
    });

    test('rejects malformed addresses', () {
      for (final email in [
        'user',
        'user@',
        '@movies.app',
        'user@movies',
        'a b@movies.app',
      ]) {
        expect(
          AuthValidators.validateEmail(email),
          EmailValidationError.invalidFormat,
          reason: '$email should be rejected',
        );
      }
    });
  });

  group('AuthValidators.validatePassword', () {
    test('reports an empty field', () {
      expect(
        AuthValidators.validatePassword(''),
        PasswordValidationError.empty,
      );
      expect(
        AuthValidators.validatePassword(null),
        PasswordValidationError.empty,
      );
    });

    test('reports a password below the minimum length', () {
      expect(
        AuthValidators.validatePassword('Ab1'),
        PasswordValidationError.tooShort,
      );
    });

    test('reports a password without a letter', () {
      expect(
        AuthValidators.validatePassword('12345678'),
        PasswordValidationError.missingLetter,
      );
    });

    test('reports a password without a digit', () {
      expect(
        AuthValidators.validatePassword('password'),
        PasswordValidationError.missingDigit,
      );
    });

    test('accepts a strong password', () {
      expect(AuthValidators.validatePassword('password1'), isNull);
    });
  });

  group('AuthValidators.validateConfirmPassword', () {
    test('reports an empty field', () {
      expect(
        AuthValidators.validateConfirmPassword('', 'password1'),
        ConfirmPasswordValidationError.empty,
      );
    });

    test('reports a mismatch', () {
      expect(
        AuthValidators.validateConfirmPassword('password2', 'password1'),
        ConfirmPasswordValidationError.mismatch,
      );
    });

    test('accepts a matching password', () {
      expect(
        AuthValidators.validateConfirmPassword('password1', 'password1'),
        isNull,
      );
    });
  });

  group('AuthValidators.validateName', () {
    test('reports an empty name', () {
      expect(AuthValidators.validateName('  '), NameValidationError.empty);
    });

    test('accepts a name', () {
      expect(AuthValidators.validateName('Mona'), isNull);
    });
  });
}
