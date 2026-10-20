/// Types of authentication failures that the UI can react to.
///
/// Sign-in problems are merged into [invalidCredentials] so the UI never
/// reveals whether an account exists for an email address.
enum AuthFailureType {
  invalidEmail,
  weakPassword,
  invalidCredentials,
  emailAlreadyInUse,
  userDisabled,
  tooManyRequests,
  networkError,
  requiresRecentLogin,
  operationNotAllowed,
  invalidActionCode,
  unknown,
}

/// Error returned by [AuthService].
///
/// Raw provider errors never leave the service: they are translated into an
/// [AuthFailure] with a [type] the UI understands.
class AuthFailure implements Exception {
  const AuthFailure(this.type, {this.cause});

  final AuthFailureType type;

  /// Technical provider code, kept for debugging only. It is never shown to
  /// the user and never contains credentials.
  final String? cause;

  @override
  String toString() => 'AuthFailure(type: $type, cause: $cause)';
}

/// Translates Firebase Authentication error codes into [AuthFailureType].
///
/// Some Firebase projects that were never configured for Authentication return
/// `internal-error` with a `CONFIGURATION_NOT_FOUND` message instead of the
/// documented `configuration-not-found` code. Treat that case as an unavailable
/// sign-in method so the UI shows an actionable message instead of a generic
/// failure.
AuthFailureType authFailureTypeFromCode(
  String code, {
  bool isActionCode = false,
  String? message,
}) {
  if (code == 'internal-error' &&
      (message?.contains('CONFIGURATION_NOT_FOUND') ?? false)) {
    return AuthFailureType.operationNotAllowed;
  }
  return switch (code) {
    'invalid-email' => AuthFailureType.invalidEmail,
    'weak-password' => AuthFailureType.weakPassword,
    'email-already-in-use' => AuthFailureType.emailAlreadyInUse,
    'user-disabled' => AuthFailureType.userDisabled,
    'too-many-requests' => AuthFailureType.tooManyRequests,
    'network-request-failed' => AuthFailureType.networkError,
    'requires-recent-login' => AuthFailureType.requiresRecentLogin,
    'operation-not-allowed' ||
    // Authentication is not configured on the Firebase project yet.
    'configuration-not-found' => AuthFailureType.operationNotAllowed,
    'expired-action-code' ||
    'invalid-action-code' => AuthFailureType.invalidActionCode,
    // When verifying a reset code, `user-not-found` means the account no
    // longer exists, so the reset link itself is not usable.
    'user-not-found' when isActionCode => AuthFailureType.invalidActionCode,
    // `wrong-password`, `user-not-found` and related codes are merged so the
    // UI cannot be used to discover registered accounts.
    'invalid-credential' ||
    'invalid-login-credentials' ||
    'wrong-password' ||
    'user-not-found' ||
    'user-mismatch' ||
    'missing-password' => AuthFailureType.invalidCredentials,
    _ => AuthFailureType.unknown,
  };
}
