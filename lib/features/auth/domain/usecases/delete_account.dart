import '../repositories/auth_repository.dart';

/// Deletes the account of the current user.
///
/// The caller must re-authenticate the user first.
class DeleteAccount {
  const DeleteAccount(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.deleteAccount();
}
