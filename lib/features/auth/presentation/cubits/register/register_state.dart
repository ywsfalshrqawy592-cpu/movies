import '../../../domain/entities/app_user.dart';
import '../../../domain/failures/auth_failure.dart';

/// Status of the registration form.
enum RegisterStatus { idle, submitting, success, failure }

/// State of the registration form.
class RegisterState {
  const RegisterState({
    this.status = RegisterStatus.idle,
    this.user,
    this.failure,
  });

  final RegisterStatus status;

  /// The created user, available once [status] is [RegisterStatus.success].
  final AppUser? user;

  /// The failure to display, available once [status] is [RegisterStatus.failure].
  final AuthFailure? failure;

  bool get isSubmitting => status == RegisterStatus.submitting;

  bool get isSuccess => status == RegisterStatus.success;

  bool get hasFailed => status == RegisterStatus.failure;
}
