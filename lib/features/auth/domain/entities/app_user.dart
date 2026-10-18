/// Application level representation of a signed-in user.
///
/// The entity is intentionally independent from Firebase so the domain layer
/// never depends on the authentication provider.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
  });

  /// Unique identifier of the user (Firebase Auth `uid`).
  final String uid;

  /// Email address of the user, `null` when the provider does not expose one.
  final String? email;

  /// Display name of the user, `null` until it is set.
  final String? displayName;

  /// Profile picture url, `null` when the user has no picture.
  final String? photoUrl;

  /// Whether the email address was verified by the provider.
  ///
  /// Only the provider can change this value, the UI must never assume that a
  /// verification email was opened successfully.
  final bool emailVerified;

  @override
  bool operator ==(Object other) =>
      other is AppUser &&
      other.uid == uid &&
      other.email == email &&
      other.displayName == displayName &&
      other.photoUrl == photoUrl &&
      other.emailVerified == emailVerified;

  @override
  int get hashCode =>
      Object.hash(uid, email, displayName, photoUrl, emailVerified);

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, emailVerified: $emailVerified)';
}
