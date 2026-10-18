import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_user.dart';
import '../../../domain/failures/auth_failure.dart';
import '../../../domain/usecases/reload_auth_user.dart';
import '../../../domain/usecases/sign_out.dart';
import '../../../domain/usecases/watch_auth_state.dart';
import 'auth_state.dart';

/// Single source of truth of the authentication session.
///
/// The cubit listens to the provider session stream, so signing in, signing out
/// or updating the profile are reflected everywhere without any screen having
/// to navigate manually.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required WatchAuthState watchAuthState,
    required this._reloadAuthUser,
    required this._signOut,
    this.requireEmailVerification = true,
  }) : super(const AuthState.unknown()) {
    _authStateSubscription = watchAuthState().listen(
      _onAuthStateChanged,
      // A broken session stream must never block the app: the user is treated
      // as signed out and can try to sign in again.
      onError: (Object _) => emit(const AuthState.unauthenticated()),
    );
  }

  /// Project policy: when `true`, unverified emails cannot reach the home
  /// screen. Set it to `false` only if the product decides otherwise.
  final bool requireEmailVerification;

  final ReloadAuthUser _reloadAuthUser;
  final SignOut _signOut;

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

  /// Reloads the provider profile and reports the *real* verification state.
  ///
  /// Returns `true` when the email is verified, `false` when it is still not
  /// verified and `null` when the profile could not be reloaded (offline for
  /// example). Pressing a button inside the app never marks an email as
  /// verified, only the provider can.
  Future<bool?> refreshUser() async {
    if (state.isRefreshing) return state.isEmailVerified;
    final currentUser = state.user;
    emit(_stateFor(currentUser, isRefreshing: true));
    try {
      final user = await _reloadAuthUser();
      emit(_stateFor(user));
      return user?.emailVerified ?? false;
    } on AuthFailure catch (failure) {
      // The reason is kept in the state so the UI can tell the user what
      // actually happened instead of a generic failure.
      emit(_stateFor(currentUser, refreshFailure: failure));
      return null;
    }
  }

  /// Ends the session; the stream then moves the app back to the login screen.
  ///
  /// Throws an [AuthFailure] when the provider could not end the session.
  Future<void> signOut() => _signOut();

  @override
  Future<void> close() async {
    await _authStateSubscription.cancel();
    return super.close();
  }
}
