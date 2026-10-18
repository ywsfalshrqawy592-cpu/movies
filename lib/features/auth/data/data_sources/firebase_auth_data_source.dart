import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../mappers/firebase_user_mapper.dart';

/// Thin wrapper around [FirebaseAuth].
///
/// The data source only exposes the operations used by the app and maps the
/// resulting [User] objects to [AppUser] entities. Errors are translated by the
/// repository, which is the layer that knows about the domain failures.
class FirebaseAuthDataSource {
  FirebaseAuthDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  /// Emits the current user and every authentication/profile change.
  ///
  /// `userChanges` is used instead of `authStateChanges` because it also fires
  /// when the profile changes, for example after the verification email link
  /// was opened and the profile was reloaded.
  Stream<AppUser?> authStateChanges() =>
      _firebaseAuth.userChanges().map(mapFirebaseUser);

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _requireUser(credential.user);
  }

  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _requireUser(credential.user);
  }

  Future<void> updateDisplayName(String name) async {
    final user = _requireFirebaseUser();
    if (user.displayName == name) return;
    await user.updateDisplayName(name);
  }

  Future<void> sendEmailVerification() async {
    await _requireFirebaseUser().sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) =>
      _firebaseAuth.sendPasswordResetEmail(email: email);

  Future<AppUser?> reloadCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    await user.reload();
    return mapFirebaseUser(_firebaseAuth.currentUser);
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<void> reauthenticateWithPassword(String password) async {
    final user = _requireFirebaseUser();
    final email = user.email;
    if (email == null) {
      // The provider never created a password based account without an email,
      // so this can only happen if the local state is inconsistent.
      throw const AuthFailure(AuthFailureType.requiresRecentLogin);
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> deleteAccount() => _requireFirebaseUser().delete();

  User _requireFirebaseUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'user-missing');
    }
    return user;
  }

  AppUser _requireUser(User? user) {
    final appUser = mapFirebaseUser(user);
    if (appUser == null) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'user-missing');
    }
    return appUser;
  }
}
