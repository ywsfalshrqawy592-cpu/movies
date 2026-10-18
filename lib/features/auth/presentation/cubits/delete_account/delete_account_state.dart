import '../../../domain/failures/auth_failure.dart';

/// Status of the "delete account" request.
enum DeleteAccountStatus { idle, submitting, success, failure }

/// State of the "delete account" request.
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
