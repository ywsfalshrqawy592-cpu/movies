import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/auth_service.dart';

/// Status of the "delete account" request.
enum DeleteAccountStatus { idle, submitting, success, failure }

class DeleteAccountState {
  const DeleteAccountState({
    this.status = DeleteAccountStatus.idle,
    this.failure,
  });

  final DeleteAccountStatus status;
  final AuthFailure? failure;

  bool get isSubmitting => status == DeleteAccountStatus.submitting;

  bool get isSuccess => status == DeleteAccountStatus.success;

  bool get hasFailed => status == DeleteAccountStatus.failure;
}

/// Deletes the account after re-authenticating the user.
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this._service) : super(const DeleteAccountState());

  final AuthService _service;

  Future<void> confirmDeletion(String password) async {
    if (state.isSubmitting) return;
    emit(const DeleteAccountState(status: DeleteAccountStatus.submitting));
    try {
      await _service.reauthenticateWithPassword(password);
      await _service.deleteAccount();
      emit(const DeleteAccountState(status: DeleteAccountStatus.success));
    } on AuthFailure catch (failure) {
      emit(
        DeleteAccountState(
          status: DeleteAccountStatus.failure,
          failure: failure,
        ),
      );
    }
  }
}
