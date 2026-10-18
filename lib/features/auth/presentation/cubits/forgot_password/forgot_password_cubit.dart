import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/failures/auth_failure.dart';
import '../../../domain/usecases/send_password_reset_email.dart';
import 'forgot_password_state.dart';

/// Handles the password reset request.
///
/// The success message is intentionally neutral: it is shown whether or not an
/// account exists for the given email address.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required this._sendPasswordResetEmail})
    : super(const ForgotPasswordState());

  final SendPasswordResetEmail _sendPasswordResetEmail;

  Future<void> submit(String email) async {
    if (state.isSubmitting) return;
    emit(const ForgotPasswordState(status: ForgotPasswordStatus.submitting));
    try {
      await _sendPasswordResetEmail(email);
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
}
