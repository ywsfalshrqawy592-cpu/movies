import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/auth_service.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';

/// Status of the registration form.
enum RegisterStatus { idle, submitting, success, failure }

class RegisterState {
  const RegisterState({
    this.status = RegisterStatus.idle,
    this.user,
    this.failure,
  });

  final RegisterStatus status;
  final AppUser? user;
  final AuthFailure? failure;

  bool get isSubmitting => status == RegisterStatus.submitting;

  bool get isSuccess => status == RegisterStatus.success;

  bool get hasFailed => status == RegisterStatus.failure;
}

/// Handles the registration form. The screen owns the field validation; the
/// cubit creates the account, the display name and the verification email.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._service) : super(const RegisterState());

  final AuthService _service;

  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(const RegisterState(status: RegisterStatus.submitting));
    try {
      final user = await _service.registerWithEmail(
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
