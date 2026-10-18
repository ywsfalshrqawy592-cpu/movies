import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/validation/auth_validators.dart';
import 'package:movies_app/features/auth/presentation/helpers/auth_messages.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/l10n/app_localizations_ar.dart';
import 'package:movies_app/l10n/app_localizations_en.dart';

void main() {
  final en = AppLocalizationsEn();
  final ar = AppLocalizationsAr();

  test('every failure type has a user facing message', () {
    for (final type in AuthFailureType.values) {
      final message = AuthMessages.failure(en, AuthFailure(type));
      expect(message, isNotEmpty, reason: '$type must be translated');
    }
  });

  test('credential failures never mention the account existence', () {
    final message = AuthMessages.failure(
      en,
      const AuthFailure(
        AuthFailureType.invalidCredentials,
        cause: 'user-not-found',
      ),
    );

    expect(message, 'Incorrect email or password.');
    expect(message, isNot(contains('user-not-found')));
  });

  test('the password policy message contains the minimum length', () {
    final message = AuthMessages.passwordError(
      en,
      PasswordValidationError.tooShort,
    );

    expect(message, contains('${AuthValidators.minPasswordLength}'));
  });

  test('validation messages are available in both languages', () {
    expect(
      AuthMessages.emailError(ar, EmailValidationError.invalidFormat),
      ar.authErrorEmailInvalid,
    );
    expect(
      AuthMessages.confirmPasswordError(
        ar,
        ConfirmPasswordValidationError.mismatch,
      ),
      ar.authErrorPasswordsDoNotMatch,
    );
    expect(
      AuthMessages.nameError(ar, NameValidationError.empty),
      ar.authErrorNameRequired,
    );
  });

  test('the generated localizations expose the authentication strings', () {
    expect(en.authLoginButton, 'Login');
    expect(en.authLogout, 'Logout');
    expect(ar.authLoginButton, 'تسجيل الدخول');
    expect(en.authResendVerificationEmailIn(30), contains('30'));
    expect(
      en.authEmailVerificationSentTo('user@movies.app'),
      contains('user@movies.app'),
    );
  });

  test('AppLocalizations resolves both supported locales', () {
    expect(
      lookupAppLocalizations(const Locale('en')),
      isA<AppLocalizationsEn>(),
    );
    expect(
      lookupAppLocalizations(const Locale('ar')),
      isA<AppLocalizationsAr>(),
    );
  });
}
