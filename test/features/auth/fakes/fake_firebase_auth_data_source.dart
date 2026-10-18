import 'package:movies_app/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:movies_app/features/auth/domain/entities/app_user.dart';

/// Stand-in for [FirebaseAuthDataSource] used by the repository tests.
///
/// It records the calls it receives and can throw any error, which is how the
/// error translation of the repository is verified without touching Firebase.
class FakeFirebaseAuthDataSource implements FirebaseAuthDataSource {
  AppUser user = const AppUser(
    uid: 'uid-1',
    email: 'user@movies.app',
    emailVerified: false,
  );

  AppUser? reloadedUser;

  /// The error thrown by the next call, `null` means success.
  Object? errorToThrow;

  final List<String> calls = <String>[];

  String? lastEmail;
  String? lastPassword;
  String? lastDisplayName;

  Future<T> _run<T>(String name, T Function() result) async {
    calls.add(name);
    final error = errorToThrow;
    if (error != null) throw error;
    return result();
  }

  @override
  Stream<AppUser?> authStateChanges() => Stream<AppUser?>.value(user);

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => _run('signIn', () {
    lastEmail = email;
    lastPassword = password;
    return user;
  });

  @override
  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) => _run('createUser', () {
    lastEmail = email;
    lastPassword = password;
    return user;
  });

  @override
  Future<void> updateDisplayName(String name) => _run('updateDisplayName', () {
    lastDisplayName = name;
  });

  @override
  Future<void> sendEmailVerification() => _run('sendEmailVerification', () {});

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _run('sendPasswordResetEmail', () {
        lastEmail = email;
      });

  @override
  Future<AppUser?> reloadCurrentUser() => _run('reload', () => reloadedUser);

  @override
  Future<void> signOut() => _run('signOut', () {});

  @override
  Future<void> reauthenticateWithPassword(String password) =>
      _run('reauthenticate', () {
        lastPassword = password;
      });

  @override
  Future<void> deleteAccount() => _run('deleteAccount', () {});
}
