/// Types of authentication failures that the presentation layer can react to.
///
/// [AuthFailureType.invalidCredentials] is used for *all* sign-in problems
/// (unknown user, wrong password, ...) so the UI never reveals whether an
/// account exists for a given email address.
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
  unknown,
}

/// Error returned by the authentication layer.
///
/// Raw provider errors (`FirebaseAuthException`) never leave the data layer:
/// they are translated into an [AuthFailure] with a [type] the UI understands.
class AuthFailure implements Exception {
  const AuthFailure(this.type, {this.cause});

  final AuthFailureType type;

  /// Technical error code returned by the authentication provider
  /// (for example `FirebaseAuthException.code`).
  ///
  /// It is kept for debugging only, it must never be shown to the user and it
  /// must never contain credentials.
  final String? cause;

  @override
  String toString() => 'AuthFailure(type: $type, cause: $cause)';
}
