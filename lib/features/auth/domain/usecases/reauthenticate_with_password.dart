import '../repositories/auth_repository.dart';

/// Re-authenticates the current user before a sensitive operation.
class ReauthenticateWithPassword {
  const ReauthenticateWithPassword(this._repository);

  final AuthRepository _repository;

  Future<void> call(String password) =>
      _repository.reauthenticateWithPassword(password);
}
