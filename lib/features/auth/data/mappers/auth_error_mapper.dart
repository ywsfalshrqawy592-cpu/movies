import '../../domain/failures/auth_failure.dart';

/// Translates provider error codes into [AuthFailure]s the app understands.
///
/// The mapping is the only place that knows about Firebase error codes, which
/// keeps the domain and the presentation layers provider agnostic.
class AuthErrorMapper {
  const AuthErrorMapper._();

  static AuthFailure fromCode(String code) =>
      AuthFailure(typeFromCode(code), cause: code);

  static AuthFailureType typeFromCode(String code) => switch (code) {
    'invalid-email' => AuthFailureType.invalidEmail,
    'weak-password' => AuthFailureType.weakPassword,
    'email-already-in-use' => AuthFailureType.emailAlreadyInUse,
    'user-disabled' => AuthFailureType.userDisabled,
    'too-many-requests' => AuthFailureType.tooManyRequests,
    'network-request-failed' => AuthFailureType.networkError,
    'requires-recent-login' => AuthFailureType.requiresRecentLogin,
    'operation-not-allowed' ||
    // The project has no Authentication configuration yet (the service was
    // never enabled in the console). The accurate user facing result is the
    // same as a disabled sign-in method.
    'configuration-not-found' => AuthFailureType.operationNotAllowed,
    // `wrong-password`, `user-not-found` and `invalid-login-credentials` are
    // merged with `invalid-credential` so the UI cannot be used to discover
    // whether an account exists for a given email address.
    'invalid-credential' ||
    'invalid-login-credentials' ||
    'wrong-password' ||
    'user-not-found' ||
    'user-mismatch' ||
    'missing-password' => AuthFailureType.invalidCredentials,
    _ => AuthFailureType.unknown,
  };
}
