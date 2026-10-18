import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/failures/auth_failure.dart';
import '../../../domain/usecases/register_with_email.dart';
import 'register_state.dart';

/// Handles the registration form: validates nothing by itself (the screen owns
/// the field validation) and creates the account, the display name and the
/// verification email in one repository call.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this._registerWithEmail})
    : super(const RegisterState());

  final RegisterWithEmail _registerWithEmail;

  /// Creates the account. Repeated calls are ignored while a request is
  /// running, which also protects against double taps on the button.
  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(const RegisterState(status: RegisterStatus.submitting));
    try {
      final user = await _registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
      emit(RegisterState(status: RegisterStatus.success, user: user));
    } on AuthFailure catch (failure) {
      emit(RegisterState(status: RegisterStatus.failure, failure: failure));
    }
  }
}
