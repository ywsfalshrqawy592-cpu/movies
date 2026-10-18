import '../../../domain/failures/auth_failure.dart';

/// Status of the verification email request.
enum EmailVerificationStatus { idle, sending, sent, failure }

/// State of the verification email request.
///
/// Checking whether the email was actually verified is *not* part of this
/// state: it belongs to `AuthCubit`, which owns the real provider session.
class EmailVerificationState {
  const EmailVerificationState({
    this.status = EmailVerificationStatus.idle,
    this.failure,
    this.cooldownSeconds = 0,
  });

  final EmailVerificationStatus status;

  /// The failure to display, available once [status] is
  /// [EmailVerificationStatus.failure].
  final AuthFailure? failure;

  /// Remaining seconds before another email can be requested.
  final int cooldownSeconds;

  bool get isSending => status == EmailVerificationStatus.sending;

  bool get canResend => !isSending && cooldownSeconds == 0;

  EmailVerificationState copyWith({
    EmailVerificationStatus? status,
    AuthFailure? failure,
    bool clearFailure = false,
    int? cooldownSeconds,
  }) => EmailVerificationState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
  );
}
