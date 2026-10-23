import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_failure.dart';
import 'package:movies_app/Ui/widgets/auth/auth_service.dart';

/// Status of the "forgot password" form.
enum ForgotPasswordStatus { idle, submitting, success, failure }

class ForgotPasswordState {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.failure,
  });

  final ForgotPasswordStatus status;
  final AuthFailure? failure;

  bool get isSubmitting => status == ForgotPasswordStatus.submitting;

  bool get isSuccess => status == ForgotPasswordStatus.success;

  bool get hasFailed => status == ForgotPasswordStatus.failure;
}

/// Sends the password reset email.
///
/// The success message is intentionally neutral: it is shown whether or not an
/// account exists for the given email address.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._service) : super(const ForgotPasswordState());

  final AuthService _service;

  Future<void> submit(String email) async {
    if (state.isSubmitting) return;
    emit(const ForgotPasswordState(status: ForgotPasswordStatus.submitting));
    try {
      await _service.sendPasswordResetEmail(email);
      emit(const ForgotPasswordState(status: ForgotPasswordStatus.success));
    } on AuthFailure catch (failure) {
      emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          failure: failure,
        ),
      );
    }
  }

  /// Clears a previous result when the user edits the email.
  void clearResult() {
    if (state.status == ForgotPasswordStatus.idle) return;
    emit(const ForgotPasswordState());
  }
}
