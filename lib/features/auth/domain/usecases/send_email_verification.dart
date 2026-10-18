import '../repositories/auth_repository.dart';

/// Sends (or re-sends) the verification email of the current user.
class SendEmailVerification {
  const SendEmailVerification(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.sendEmailVerification();
}
