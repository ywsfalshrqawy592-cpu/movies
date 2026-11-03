import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_failure.dart';
import 'package:movies_app/Ui/widgets/auth/auth_service.dart';
import 'package:movies_app/Ui/widgets/auth/auth_user.dart';

/// High level authentication status of the application.
enum AuthStatus {
  /// The session is being restored and we do not know yet whether a user is
  /// signed in.
  unknown,

  /// No user is signed in.
  unauthenticated,

  /// A user is signed in but the email address is not verified yet.
  emailNotVerified,

  /// A user is signed in and (when required) the email is verified.
  authenticated,
}

/// State of the authentication session.
class AuthState {
  const AuthState._({
    required this.status,
    this.user,
    this.isRefreshing = false,
    this.refreshFailure,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  factory AuthState.fromUser(
    AppUser? user, {
    bool requireEmailVerification = true,
    bool isRefreshing = false,
    AuthFailure? refreshFailure,
  }) {
    if (user == null) return const AuthState.unauthenticated();
    final status = requireEmailVerification && !user.emailVerified
        ? AuthStatus.emailNotVerified
        : AuthStatus.authenticated;
    return AuthState._(
      status: status,
      user: user,
      isRefreshing: isRefreshing,
      refreshFailure: refreshFailure,
    );
  }

  final AuthStatus status;
  final AppUser? user;
  final bool isRefreshing;
  final AuthFailure? refreshFailure;

  bool get isSignedIn => user != null;

  bool get isEmailVerified => user?.emailVerified ?? false;
}

/// Single source of truth of the authentication session.
///
/// It listens to the provider session stream, so signing in, signing out or
/// updating the profile is reflected everywhere without any screen having to
/// navigate manually.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.service, {this.requireEmailVerification = true})
    : super(const AuthState.unknown()) {
    _authStateSubscription = service.authStateChanges().listen(
      _onAuthStateChanged,
      // A broken session stream must never block the app: the user is treated
      // as signed out and can try to sign in again.
      onError: (Object _) => emit(const AuthState.unauthenticated()),
    );
  }

  final AuthService service;

  /// Project policy: when `true`, unverified emails cannot reach the home
  /// screen.
  final bool requireEmailVerification;

  late final StreamSubscription<AppUser?> _authStateSubscription;

  void _onAuthStateChanged(AppUser? user) => emit(_stateFor(user));

  AuthState _stateFor(
    AppUser? user, {
    bool isRefreshing = false,
    AuthFailure? refreshFailure,
  }) => AuthState.fromUser(
    user,
    requireEmailVerification: requireEmailVerification,
    isRefreshing: isRefreshing,
    refreshFailure: refreshFailure,
  );

  /// Reloads the provider profile and reports the real verification state.
  ///
  /// Returns `true` when verified, `false` when still unverified and `null`
  /// when the profile could not be reloaded (for example offline).
  Future<bool?> refreshUser() async {
    if (state.isRefreshing) return state.isEmailVerified;
    final currentUser = state.user;
    emit(_stateFor(currentUser, isRefreshing: true));
    try {
      final user = await service.reloadCurrentUser();
      emit(_stateFor(user));
      return user?.emailVerified ?? false;
    } on AuthFailure catch (failure) {
      emit(_stateFor(currentUser, refreshFailure: failure));
      return null;
    }
  }

  /// Ends the session; the stream moves the app back to the login screen.
  Future<void> signOut() => service.signOut();

  @override
  Future<void> close() async {
    await _authStateSubscription.cancel();
    return super.close();
  }
}
