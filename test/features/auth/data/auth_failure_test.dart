import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';

void main() {
  group('authFailureTypeFromCode', () {
    test('maps the known Firebase Authentication codes', () {
      expect(
        authFailureTypeFromCode('invalid-email'),
        AuthFailureType.invalidEmail,
      );
      expect(
        authFailureTypeFromCode('weak-password'),
        AuthFailureType.weakPassword,
      );
      expect(
        authFailureTypeFromCode('email-already-in-use'),
        AuthFailureType.emailAlreadyInUse,
      );
      expect(
        authFailureTypeFromCode('too-many-requests'),
        AuthFailureType.tooManyRequests,
      );
      expect(
        authFailureTypeFromCode('network-request-failed'),
        AuthFailureType.networkError,
      );
      expect(
        authFailureTypeFromCode('requires-recent-login'),
        AuthFailureType.requiresRecentLogin,
      );
      expect(
        authFailureTypeFromCode('operation-not-allowed'),
        AuthFailureType.operationNotAllowed,
      );
      expect(
        authFailureTypeFromCode('configuration-not-found'),
        AuthFailureType.operationNotAllowed,
      );
    });

    test('never reveals whether an account exists', () {
      for (final code in [
        'invalid-credential',
        'invalid-login-credentials',
        'wrong-password',
        'user-not-found',
        'user-mismatch',
        'missing-password',
      ]) {
        expect(
          authFailureTypeFromCode(code),
          AuthFailureType.invalidCredentials,
          reason: code,
        );
      }
    });

    test('marks reset-link failures as invalid action codes', () {
      expect(
        authFailureTypeFromCode('expired-action-code'),
        AuthFailureType.invalidActionCode,
      );
      expect(
        authFailureTypeFromCode('invalid-action-code'),
        AuthFailureType.invalidActionCode,
      );
      expect(
        authFailureTypeFromCode('user-not-found', isActionCode: true),
        AuthFailureType.invalidActionCode,
      );
    });

    test('recognizes a missing Authentication configuration', () {
      expect(
        authFailureTypeFromCode(
          'internal-error',
          message:
              'An internal error has occurred. [ CONFIGURATION_NOT_FOUND ]',
        ),
        AuthFailureType.operationNotAllowed,
      );
      expect(
        authFailureTypeFromCode('internal-error'),
        AuthFailureType.unknown,
      );
    });

    test('falls back to unknown for unmapped codes', () {
      expect(authFailureTypeFromCode('something-new'), AuthFailureType.unknown);
    });
  });
}
