import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/failures/auth_failure.dart';
import '../../../domain/usecases/sign_in_with_email.dart';
import 'login_state.dart';

/// Handles the login form: one request at a time, errors translated to
/// [AuthFailure]s that the screen renders next to the fields.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this._signInWithEmail}) : super(const LoginState());

  final SignInWithEmail _signInWithEmail;

  /// Signs the user in. Repeated calls are ignored while a request is running,
  /// which also protects against double taps on the login button.
  Future<void> submit({required String email, required String password}) async {
    if (state.isSubmitting) return;
    emit(const LoginState(status: LoginStatus.submitting));
    try {
      final user = await _signInWithEmail(email: email, password: password);
      emit(LoginState(status: LoginStatus.success, user: user));
    } on AuthFailure catch (failure) {
      emit(LoginState(status: LoginStatus.failure, failure: failure));
    }
  }
}
