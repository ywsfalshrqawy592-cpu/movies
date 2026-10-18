import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';

/// Converts a Firebase [User] into the application [AppUser] entity.
///
/// Keeping the mapping in one place means the rest of the app never imports
/// `package:firebase_auth` outside of the data layer.
AppUser? mapFirebaseUser(User? user) {
  if (user == null) return null;
  return AppUser(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    emailVerified: user.emailVerified,
  );
}
