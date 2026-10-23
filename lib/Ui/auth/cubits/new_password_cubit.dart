import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/auth_service.dart';

/// Status of the "set a new password" screen.
enum NewPasswordStatus {
  verifying,
  ready,
  submitting,
  success,
  invalidLink,
  failure,
}

class NewPasswordState {
  const NewPasswordState({
    this.status = NewPasswordStatus.verifying,
    this.email,
    this.failure,
  });

  final NewPasswordStatus status;

  /// Email extracted from the reset code, available once the link is valid.
  final String? email;

  final AuthFailure? failure;

  bool get isVerifying => status == NewPasswordStatus.verifying;

  bool get isReady => status == NewPasswordStatus.ready;

  bool get isSubmitting => status == NewPasswordStatus.submitting;

  bool get isSuccess => status == NewPasswordStatus.success;

  /// The code was rejected by the provider (expired, used or malformed).
  bool get hasInvalidLink => status == NewPasswordStatus.invalidLink;

  /// Saving the new password failed, but the form can be retried.
  bool get hasFailed => status == NewPasswordStatus.failure;
}

/// Verifies a Firebase password reset code and saves the new password.
class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit(this._service, this.code) : super(const NewPasswordState()) {
    _verifyCode();
  }

  final AuthService _service;
  final String code;

  Future<void> _verifyCode() async {
    if (code.trim().isEmpty) {
      emit(
        const NewPasswordState(
          status: NewPasswordStatus.invalidLink,
          failure: AuthFailure(AuthFailureType.invalidActionCode),
        ),
      );
      return;
    }
    try {
      final email = await _service.verifyPasswordResetCode(code);
      emit(NewPasswordState(status: NewPasswordStatus.ready, email: email));
    } on AuthFailure catch (failure) {
      emit(
        NewPasswordState(
          status: NewPasswordStatus.invalidLink,
          failure: failure,
        ),
      );
    }
  }

  Future<void> submit(String newPassword) async {
    if (!state.isReady) return;
    emit(
      NewPasswordState(
        status: NewPasswordStatus.submitting,
        email: state.email,
      ),
    );
    try {
      await _service.confirmPasswordReset(code: code, newPassword: newPassword);
      emit(
        NewPasswordState(status: NewPasswordStatus.success, email: state.email),
      );
    } on AuthFailure catch (failure) {
      emit(
        NewPasswordState(
          status: NewPasswordStatus.failure,
          email: state.email,
          failure: failure,
        ),
      );
    }
  }
}
