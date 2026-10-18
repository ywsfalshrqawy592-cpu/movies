import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Creates a new account and triggers the verification email.
class RegisterWithEmail {
  const RegisterWithEmail(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({
    required String name,
    required String email,
    required String password,
  }) => _repository.registerWithEmail(
    name: name,
    email: email,
    password: password,
  );
}
