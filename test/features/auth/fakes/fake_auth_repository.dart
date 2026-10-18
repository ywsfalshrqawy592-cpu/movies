import 'dart:async';

import 'package:movies_app/features/auth/domain/entities/app_user.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

/// In-memory [AuthRepository] used by the tests.
///
/// It behaves like the provider: signing in or out publishes a new state so the
/// widgets react exactly like they do in production, and every operation can be
/// configured to fail or to stay pending.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? initialUser}) : _currentUser = initialUser;

  final StreamController<AppUser?> _stateController =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

  /// User returned by a successful [signInWithEmail].
  AppUser signInUser = const AppUser(
    uid: 'uid-1',
    email: 'user@movies.app',
    displayName: 'Test User',
    emailVerified: true,
  );

  /// User returned by a successful [registerWithEmail].
  AppUser registerUser = const AppUser(
    uid: 'uid-2',
    email: 'new@movies.app',
    displayName: 'New User',
    emailVerified: false,
  );

  /// User returned by [reloadCurrentUser]; `null` returns the current user.
  AppUser? reloadUser;

  AuthFailure? signInFailure;
  AuthFailure? registerFailure;
  AuthFailure? signOutFailure;
  AuthFailure? sendEmailVerificationFailure;
  AuthFailure? sendPasswordResetEmailFailure;
  AuthFailure? reloadFailure;
  AuthFailure? reauthenticateFailure;
  AuthFailure? deleteAccountFailure;

  /// When completed, the matching operation resolves; used to observe loading
  /// states and to try to submit twice while a request is in flight.
  Completer<void>? pendingSignIn;
  Completer<void>? pendingRegister;
  Completer<void>? pendingReload;

  int signInCalls = 0;
  int registerCalls = 0;
  int signOutCalls = 0;
  int sendEmailVerificationCalls = 0;
  int sendPasswordResetEmailCalls = 0;
  int reloadCurrentUserCalls = 0;
  int reauthenticateCalls = 0;
  int deleteAccountCalls = 0;

  String? lastSignInEmail;
  String? lastSignInPassword;
  String? lastRegisteredName;
  String? lastRegisteredEmail;
  String? lastPasswordResetEmail;
  String? lastReauthenticatedPassword;

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

  Future<void> dispose() => _stateController.close();

  void _throwIfNeeded(AuthFailure? failure) {
    if (failure != null) throw failure;
  }

  void _emit(AppUser? user) {
    _currentUser = user;
    if (!_stateController.isClosed) _stateController.add(user);
  }
}
