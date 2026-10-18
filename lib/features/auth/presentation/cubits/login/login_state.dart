import '../../../domain/entities/app_user.dart';
import '../../../domain/failures/auth_failure.dart';

/// Status of the login form.
enum LoginStatus { idle, submitting, success, failure }

/// State of the login form.
class LoginState {
  const LoginState({this.status = LoginStatus.idle, this.user, this.failure});

  final LoginStatus status;

  /// The signed-in user, available once [status] is [LoginStatus.success].
  final AppUser? user;

  /// The failure to display, available once [status] is [LoginStatus.failure].
  final AuthFailure? failure;

  bool get isSubmitting => status == LoginStatus.submitting;

  bool get hasFailed => status == LoginStatus.failure;
}
