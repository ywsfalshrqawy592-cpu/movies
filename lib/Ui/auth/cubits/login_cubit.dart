import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/auth_service.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';

/// Status of the login form.
enum LoginStatus { idle, submitting, success, failure }

class LoginState {
  const LoginState({this.status = LoginStatus.idle, this.user, this.failure});

  final LoginStatus status;
  final AppUser? user;
  final AuthFailure? failure;

  bool get isSubmitting => status == LoginStatus.submitting;

  bool get hasFailed => status == LoginStatus.failure;
}

/// Handles the login form: one request at a time and errors translated to
/// [AuthFailure]s that the screen renders next to the fields.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._service) : super(const LoginState());

  final AuthService _service;

  Future<void> submit({required String email, required String password}) async {
    if (state.isSubmitting) return;
    emit(const LoginState(status: LoginStatus.submitting));
    try {
      final user = await _service.signInWithEmail(
        email: email,
        password: password,
      );
      emit(LoginState(status: LoginStatus.success, user: user));
    } on AuthFailure catch (failure) {
      emit(LoginState(status: LoginStatus.failure, failure: failure));
    }
  }
}
