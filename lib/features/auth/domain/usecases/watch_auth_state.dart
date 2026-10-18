import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Streams the authentication state so the app can react to sign-in, sign-out
/// and profile changes from a single place.
class WatchAuthState {
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  Stream<AppUser?> call() => _repository.authStateChanges();
}
