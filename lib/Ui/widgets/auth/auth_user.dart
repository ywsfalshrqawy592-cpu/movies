/// Application level representation of a signed-in user.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
  });

  final String uid;
  final String? email;
  final String? displayName;

  /// Profile picture. The project stores the selected bundled avatar path here
  /// (`assets/images/avatarN.png`), but a normal URL is supported as well.
  final String? photoUrl;

  /// Whether the provider verified the email address. Only the provider can
  /// change this value.
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
