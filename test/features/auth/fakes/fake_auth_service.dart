import 'dart:async';

import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/auth_service.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';

/// In-memory [AuthService] used by the tests.
///
/// It behaves like the provider: signing in or out publishes a new state so the
/// widgets react exactly like they do in production, and every operation can be
/// configured to fail or to stay pending.
class FakeAuthService extends AuthService {
  FakeAuthService({AppUser? initialUser}) : _currentUser = initialUser;

  final StreamController<AppUser?> _stateController =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

  AppUser signInUser = const AppUser(
    uid: 'uid-1',
    email: 'user@movies.app',
    displayName: 'Test User',
    emailVerified: true,
  );

  AppUser registerUser = const AppUser(
    uid: 'uid-2',
    email: 'new@movies.app',
    displayName: 'New User',
    emailVerified: false,
  );

  AppUser? reloadUser;

  AuthFailure? signInFailure;
  AuthFailure? registerFailure;
  AuthFailure? signOutFailure;
  AuthFailure? sendEmailVerificationFailure;
  AuthFailure? sendPasswordResetEmailFailure;
  AuthFailure? reloadFailure;
  AuthFailure? reauthenticateFailure;
  AuthFailure? deleteAccountFailure;
  AuthFailure? updateProfileFailure;
  AuthFailure? verifyResetCodeFailure;
  AuthFailure? confirmPasswordResetFailure;

  Completer<void>? pendingSignIn;
  Completer<void>? pendingRegister;
  Completer<void>? pendingReload;
  Completer<void>? pendingUpdate;
  Completer<void>? pendingConfirmReset;

  int signInCalls = 0;
  int registerCalls = 0;
  int signOutCalls = 0;
  int sendEmailVerificationCalls = 0;
  int sendPasswordResetEmailCalls = 0;
  int reloadCurrentUserCalls = 0;
  int reauthenticateCalls = 0;
  int deleteAccountCalls = 0;
  int updateProfileCalls = 0;
  int verifyResetCodeCalls = 0;
  int confirmPasswordResetCalls = 0;

  String? lastSignInEmail;
  String? lastSignInPassword;
  String? lastRegisteredName;
  String? lastRegisteredEmail;
  String? lastPasswordResetEmail;
  String? lastReauthenticatedPassword;
  String? lastUpdatedName;
  String? lastUpdatedPhotoUrl;
  String? lastResetCode;
  String? lastConfirmedResetCode;
  String? lastConfirmedNewPassword;

  /// Email returned by a valid reset code.
  String resetCodeEmail = 'user@movies.app';

  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _currentUser;
    yield* _stateController.stream;
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    lastSignInEmail = email;
    lastSignInPassword = password;
    if (pendingSignIn != null) await pendingSignIn!.future;
    _throwIfNeeded(signInFailure);
    _emit(signInUser);
    return signInUser;
  }

  @override
  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    registerCalls++;
    lastRegisteredName = name;
    lastRegisteredEmail = email;
    if (pendingRegister != null) await pendingRegister!.future;
    _throwIfNeeded(registerFailure);
    _emit(registerUser);
    return registerUser;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _throwIfNeeded(signOutFailure);
    _emit(null);
  }

  @override
  Future<void> sendEmailVerification() async {
    sendEmailVerificationCalls++;
    _throwIfNeeded(sendEmailVerificationFailure);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    sendPasswordResetEmailCalls++;
    lastPasswordResetEmail = email;
    _throwIfNeeded(sendPasswordResetEmailFailure);
  }

  @override
  Future<AppUser?> reloadCurrentUser() async {
    reloadCurrentUserCalls++;
    if (pendingReload != null) await pendingReload!.future;
    _throwIfNeeded(reloadFailure);
    final user = reloadUser ?? _currentUser;
    _emit(user);
    return user;
  }

  @override
  Future<AppUser> updateProfile({
    required String name,
    String? photoUrl,
  }) async {
    updateProfileCalls++;
    lastUpdatedName = name;
    lastUpdatedPhotoUrl = photoUrl;
    if (pendingUpdate != null) await pendingUpdate!.future;
    _throwIfNeeded(updateProfileFailure);
    final current = _currentUser;
    if (current == null) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'user-missing');
    }
    final updated = AppUser(
      uid: current.uid,
      email: current.email,
      displayName: name.trim(),
      photoUrl: photoUrl ?? current.photoUrl,
      emailVerified: current.emailVerified,
    );
    _emit(updated);
    return updated;
  }

  @override
  Future<void> reauthenticateWithPassword(String password) async {
    reauthenticateCalls++;
    lastReauthenticatedPassword = password;
    _throwIfNeeded(reauthenticateFailure);
  }

  @override
  Future<void> deleteAccount() async {
    deleteAccountCalls++;
    _throwIfNeeded(deleteAccountFailure);
    _emit(null);
  }

  @override
  Future<String> verifyPasswordResetCode(String code) async {
    verifyResetCodeCalls++;
    lastResetCode = code;
    _throwIfNeeded(verifyResetCodeFailure);
    return resetCodeEmail;
  }

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    confirmPasswordResetCalls++;
    lastConfirmedResetCode = code;
    lastConfirmedNewPassword = newPassword;
    if (pendingConfirmReset != null) await pendingConfirmReset!.future;
    _throwIfNeeded(confirmPasswordResetFailure);
  }

  Future<void> dispose() => _stateController.close();

  void _throwIfNeeded(AuthFailure? failure) {
    if (failure != null) throw failure;
  }

  void _emit(AppUser? user) {
    _currentUser = user;
    if (!_stateController.isClosed) _stateController.add(user);
  }
}
