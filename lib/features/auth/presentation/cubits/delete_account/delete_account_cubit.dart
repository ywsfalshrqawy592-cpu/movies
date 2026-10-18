import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/failures/auth_failure.dart';
import '../../../domain/usecases/delete_account.dart';
import '../../../domain/usecases/reauthenticate_with_password.dart';
import 'delete_account_state.dart';

/// Deletes the account after re-authenticating the user.
///
/// Re-authentication is required by the provider for sensitive operations, and
/// the app asks for it up front so a stale session cannot be used to delete an
/// account.
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit({
    required this._reauthenticateWithPassword,
    required this._deleteAccount,
  }) : super(const DeleteAccountState());

  final ReauthenticateWithPassword _reauthenticateWithPassword;
  final DeleteAccount _deleteAccount;

  Future<void> confirmDeletion(String password) async {
    if (state.isSubmitting) return;
    emit(const DeleteAccountState(status: DeleteAccountStatus.submitting));
    try {
      await _reauthenticateWithPassword(password);
      await _deleteAccount();
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
