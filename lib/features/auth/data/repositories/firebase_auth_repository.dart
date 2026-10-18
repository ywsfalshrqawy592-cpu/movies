import 'package:firebase_core/firebase_core.dart' show FirebaseException;

import '../../domain/entities/app_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/validation/auth_validators.dart';
import '../data_sources/firebase_auth_data_source.dart';
import '../mappers/auth_error_mapper.dart';

/// Firebase Authentication implementation of [AuthRepository].
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._dataSource);

  final FirebaseAuthDataSource _dataSource;

  @override
  Stream<AppUser?> authStateChanges() => _dataSource.authStateChanges();

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) => _guard(
    () => _dataSource.signInWithEmailAndPassword(
      email: AuthValidators.normalizeEmail(email),
      password: password,
    ),
  );

  @override
  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) => _guard(() async {
    final user = await _dataSource.createUserWithEmailAndPassword(
      email: AuthValidators.normalizeEmail(email),
      password: password,
    );
    await _dataSource.updateDisplayName(name.trim());
    await _dataSource.sendEmailVerification();
    return user;
  });

  @override
  Future<void> sendPasswordResetEmail(String email) => _guard(
    () => _dataSource.sendPasswordResetEmail(
      AuthValidators.normalizeEmail(email),
    ),
  );

  @override
  Future<void> sendEmailVerification() =>
      _guard(_dataSource.sendEmailVerification);

  @override
  Future<AppUser?> reloadCurrentUser() => _guard(_dataSource.reloadCurrentUser);

  @override
  Future<void> reauthenticateWithPassword(String password) =>
      _guard(() => _dataSource.reauthenticateWithPassword(password));

  @override
  Future<void> deleteAccount() => _guard(_dataSource.deleteAccount);

  @override
  Future<void> signOut() => _guard(_dataSource.signOut);

  /// Runs [action] and converts every provider error into an [AuthFailure].
  ///
  /// No raw exception is allowed to reach the presentation layer.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthFailure {
      rethrow;
    } on FirebaseException catch (error) {
      throw AuthErrorMapper.fromCode(error.code);
    } catch (error) {
      throw const AuthFailure(AuthFailureType.unknown, cause: 'unexpected');
    }
  }
}
