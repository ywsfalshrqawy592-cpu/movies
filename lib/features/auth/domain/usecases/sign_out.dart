import '../repositories/auth_repository.dart';

/// Ends the current session without deleting any data.
class SignOut {
  const SignOut(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signOut();
}
