import '../../../domain/failures/auth_failure.dart';

/// Status of the "forgot password" form.
enum ForgotPasswordStatus { idle, submitting, success, failure }

/// State of the "forgot password" form.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.failure,
  });

  final ForgotPasswordStatus status;

  /// The failure to display, available once [status] is
  /// [ForgotPasswordStatus.failure].
  final AuthFailure? failure;

  bool get isSubmitting => status == ForgotPasswordStatus.submitting;

  bool get isSuccess => status == ForgotPasswordStatus.success;

  bool get hasFailed => status == ForgotPasswordStatus.failure;
}
