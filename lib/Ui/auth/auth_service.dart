import 'package:firebase_auth/firebase_auth.dart';

import 'auth_failure.dart';
import 'auth_user.dart';
import 'auth_validators.dart';

/// All Firebase Authentication calls used by the app.
///
/// This is the single place that knows about Firebase types and error codes.
/// Cubits call it directly, matching how the rest of the project keeps its
/// state management simple (see `LanguageCubit` and `OnboardingCubit`).
class AuthService {
  AuthService([this._firebaseAuth]);

  final FirebaseAuth? _firebaseAuth;

  FirebaseAuth get _auth => _firebaseAuth ?? FirebaseAuth.instance;

  /// Emits the current user and every session/profile change.
  ///
  /// `userChanges` also fires after a profile update and after the email was
  /// verified, which is what keeps the UI in sync without manual navigation.
  Stream<AppUser?> authStateChanges() => _auth.userChanges().map(_mapUser);

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) => _guard(() async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: AuthValidators.normalizeEmail(email),
      password: password,
    );
    return _requireUser(credential.user);
  });

  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) => _guard(() async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: AuthValidators.normalizeEmail(email),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'user-missing');
    }
    await user.updateDisplayName(name.trim());
    await user.sendEmailVerification();
    await user.reload();
    return _requireUser(_auth.currentUser);
  });

  Future<void> sendPasswordResetEmail(String email) => _guard(
    () => _auth.sendPasswordResetEmail(
      email: AuthValidators.normalizeEmail(email),
    ),
  );

  /// Verifies the code of a password reset link and returns its email.
  ///
  /// Throws [AuthFailureType.invalidActionCode] when the link is expired,
  /// already used or otherwise invalid.
  Future<String> verifyPasswordResetCode(String code) =>
      _guardAction(() => _auth.verifyPasswordResetCode(code));

  /// Saves the new password for a verified reset code.
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) => _guardAction(
    () => _auth.confirmPasswordReset(code: code, newPassword: newPassword),
  );

  Future<void> sendEmailVerification() =>
      _guard(() => _requireFirebaseUser().sendEmailVerification());

  Future<AppUser?> reloadCurrentUser() => _guard(() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    await user.reload();
    return _mapUser(_auth.currentUser);
  });

  /// Updates the editable parts of the provider profile.
  ///
  /// The bundled avatar path is stored in `photoURL`, so the choice follows
  /// the account on every device that uses the same Firebase profile.
  Future<AppUser> updateProfile({required String name, String? photoUrl}) =>
      _guard(() async {
        final user = _requireFirebaseUser();
        final displayName = name.trim();
        if (user.displayName != displayName) {
          await user.updateDisplayName(displayName);
        }
        if (photoUrl != null && user.photoURL != photoUrl) {
          await user.updatePhotoURL(photoUrl);
        }
        await user.reload();
        return _requireUser(_auth.currentUser);
      });

  Future<void> reauthenticateWithPassword(String password) => _guard(() async {
    final user = _requireFirebaseUser();
    final email = user.email;
    if (email == null) {
      throw const AuthFailure(AuthFailureType.requiresRecentLogin);
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  });

  Future<void> deleteAccount() => _guard(() => _requireFirebaseUser().delete());

  Future<void> signOut() => _guard(() => _auth.signOut());

  AppUser _requireUser(User? user) {
    final appUser = _mapUser(user);
    if (appUser == null) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'user-missing');
    }
    return appUser;
  }

  User _requireFirebaseUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'user-missing');
    }
    return user;
  }

  AppUser? _mapUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  Future<T> _guard<T>(Future<T> Function() action) =>
      _guardWith(action, isActionCode: false);

  Future<T> _guardAction<T>(Future<T> Function() action) =>
      _guardWith(action, isActionCode: true);

  Future<T> _guardWith<T>(
    Future<T> Function() action, {
    required bool isActionCode,
  }) async {
    try {
      return await action();
    } on AuthFailure {
      rethrow;
    } on FirebaseException catch (error) {
      throw AuthFailure(
        authFailureTypeFromCode(
          error.code,
          isActionCode: isActionCode,
          message: error.message,
        ),
        cause: error.code,
      );
    } catch (_) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'unexpected');
    }
  }
}
