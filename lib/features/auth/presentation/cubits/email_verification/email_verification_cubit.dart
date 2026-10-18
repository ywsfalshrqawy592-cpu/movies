import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/failures/auth_failure.dart';
import '../../../domain/usecases/send_email_verification.dart';
import 'email_verification_state.dart';

/// Handles (re)sending the verification email.
///
/// A cooldown is applied after every attempt so the user cannot spam the
/// provider and hit its rate limit; provider rate limit errors are still
/// translated and shown when they happen anyway.
class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit({required this._sendEmailVerification})
    : super(const EmailVerificationState());

  /// Number of seconds the resend button stays disabled after one attempt.
  static const int resendCooldownSeconds = 60;

  final SendEmailVerification _sendEmailVerification;

  Timer? _cooldownTimer;

  Future<void> resendEmail() async {
    if (!state.canResend) return;
    emit(
      state.copyWith(
        status: EmailVerificationStatus.sending,
        clearFailure: true,
      ),
    );
    try {
      await _sendEmailVerification();
      emit(state.copyWith(status: EmailVerificationStatus.sent));
      _startCooldown();
    } on AuthFailure catch (failure) {
      emit(
        state.copyWith(
          status: EmailVerificationStatus.failure,
          failure: failure,
        ),
      );
      // A rate limited provider is a reason to slow down as well.
      if (failure.type == AuthFailureType.tooManyRequests) _startCooldown();
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _emitCooldown(resendCooldownSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.cooldownSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        _emitCooldown(0);
      } else {
        _emitCooldown(remaining);
      }
    });
  }

  void _emitCooldown(int seconds) =>
      emit(state.copyWith(cooldownSeconds: seconds));

  @override
  Future<void> close() async {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
