import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/data/mappers/auth_error_mapper.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';

void main() {
  group('AuthErrorMapper.typeFromCode', () {
    test('maps the known Firebase Authentication codes', () {
      expect(
        AuthErrorMapper.typeFromCode('invalid-email'),
        AuthFailureType.invalidEmail,
      );
      expect(
        AuthErrorMapper.typeFromCode('weak-password'),
        AuthFailureType.weakPassword,
      );
      expect(
        AuthErrorMapper.typeFromCode('email-already-in-use'),
        AuthFailureType.emailAlreadyInUse,
      );
      expect(
        AuthErrorMapper.typeFromCode('user-disabled'),
        AuthFailureType.userDisabled,
      );
      expect(
        AuthErrorMapper.typeFromCode('too-many-requests'),
        AuthFailureType.tooManyRequests,
      );
      expect(
        AuthErrorMapper.typeFromCode('network-request-failed'),
        AuthFailureType.networkError,
      );
      expect(
        AuthErrorMapper.typeFromCode('requires-recent-login'),
        AuthFailureType.requiresRecentLogin,
      );
      expect(
        AuthErrorMapper.typeFromCode('operation-not-allowed'),
        AuthFailureType.operationNotAllowed,
      );
      // Live project state during the audit: Authentication was never enabled
      // in the console, which the SDK reports as `configuration-not-found`.
      expect(
        AuthErrorMapper.typeFromCode('configuration-not-found'),
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
          AuthErrorMapper.typeFromCode(code),
          AuthFailureType.invalidCredentials,
          reason: '$code must not be distinguishable in the UI',
        );
      }
    });

    test('falls back to unknown for unmapped codes', () {
      expect(
        AuthErrorMapper.typeFromCode('internal-error'),
        AuthFailureType.unknown,
      );
      expect(AuthErrorMapper.typeFromCode(''), AuthFailureType.unknown);
    });

    test('keeps the provider code for debugging only', () {
      final failure = AuthErrorMapper.fromCode('invalid-credential');
      expect(failure.cause, 'invalid-credential');
      expect(failure.toString(), contains('invalidCredentials'));
    });
  });
}
