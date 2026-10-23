import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_failure.dart';
import 'package:movies_app/Ui/widgets/auth/auth_service.dart';

/// Status of the verification email request.
enum EmailVerificationStatus { idle, sending, sent, failure }

class EmailVerificationState {
  const EmailVerificationState({
    this.status = EmailVerificationStatus.idle,
    this.failure,
    this.cooldownSeconds = 0,
  });

  final EmailVerificationStatus status;
  final AuthFailure? failure;
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

/// Handles (re)sending the verification email.
///
/// A cooldown is applied after every attempt so the user cannot spam the
/// provider and hit its rate limit.
class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit(this._service) : super(const EmailVerificationState());

  static const int resendCooldownSeconds = 60;

  final AuthService _service;
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
      await _service.sendEmailVerification();
      emit(state.copyWith(status: EmailVerificationStatus.sent));
      _startCooldown();
    } on AuthFailure catch (failure) {
      emit(
        state.copyWith(
          status: EmailVerificationStatus.failure,
          failure: failure,
        ),
      );
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
