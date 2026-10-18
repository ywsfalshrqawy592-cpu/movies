import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Reloads the provider profile of the current user.
class ReloadAuthUser {
  const ReloadAuthUser(this._repository);

  final AuthRepository _repository;

  Future<AppUser?> call() => _repository.reloadCurrentUser();
}
