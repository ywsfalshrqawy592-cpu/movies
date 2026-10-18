import '../entities/app_user.dart';

/// Contract of the authentication operations used by the application.
///
/// Implementations live in the data layer and are responsible for talking to
/// the authentication provider (Firebase Authentication) and for translating
/// provider errors into `AuthFailure`s.
abstract class AuthRepository {
  /// Emits the current user (or `null`) and every session/profile change.
  ///
  /// Implementations must rely on the official provider session API instead of
  /// storing passwords or session tokens themselves.
  Stream<AppUser?> authStateChanges();

  /// Signs in with an email and a password.
  ///
  /// Throws an `AuthFailure` with [AuthFailureType.invalidCredentials] when the
  /// credentials are wrong, without disclosing whether the account exists.
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  /// Creates an account, sets the display name and sends a verification email.
  ///
  /// Creating the account does not mean the profile is complete: the user is
  /// signed in but still has to verify the email address.
  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  /// Ends the current session. Local (non authentication) data is preserved.
  Future<void> signOut();

  /// Sends the verification email to the currently signed-in user.
  Future<void> sendEmailVerification();

  /// Sends a password reset email.
  ///
  /// The call is intentionally neutral: the caller shows the same confirmation
  /// message whether or not an account exists for [email].
  Future<void> sendPasswordResetEmail(String email);

  /// Reloads the provider profile of the current user and returns it.
  ///
  /// Used to read the real `emailVerified` flag after the user opened the
  /// verification link outside of the application.
  Future<AppUser?> reloadCurrentUser();

  /// Re-authenticates the current user with the given password.
  ///
  /// Required before sensitive operations such as deleting the account.
  Future<void> reauthenticateWithPassword(String password);

  /// Permanently deletes the account of the current user.
  Future<void> deleteAccount();
}
