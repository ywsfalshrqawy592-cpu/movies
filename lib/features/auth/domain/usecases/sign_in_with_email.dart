import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Signs in an existing user with an email and a password.
class SignInWithEmail {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({required String email, required String password}) =>
      _repository.signInWithEmail(email: email, password: password);
}
