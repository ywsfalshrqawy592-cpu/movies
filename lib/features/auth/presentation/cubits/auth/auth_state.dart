import 'package:movies_app/features/auth/domain/entities/app_user.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';

/// High level authentication status of the application.
enum AuthStatus {
  /// The first state of the app: the session is being restored and we do not
  /// know yet whether a user is signed in.
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

  /// Builds the state that matches [user].
  ///
  /// [requireEmailVerification] is the project policy: when it is `true` a
  /// signed-in user with an unverified email is routed to the verification
  /// screen instead of the home screen.
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

  /// The signed-in user, `null` when nobody is signed in.
  final AppUser? user;

  /// `true` while the profile is being reloaded from the provider.
  final bool isRefreshing;

  /// Why the last profile reload failed, `null` when it succeeded or none was
  /// requested yet. The verification screen shows this exact reason (offline,
  /// rate limited, ...) instead of a generic message.
  final AuthFailure? refreshFailure;

  bool get isSignedIn => user != null;

  bool get isEmailVerified => user?.emailVerified ?? false;
}
