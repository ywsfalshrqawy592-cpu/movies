import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';

import '../fakes/fake_firebase_auth_data_source.dart';

void main() {
  late FakeFirebaseAuthDataSource dataSource;
  late FirebaseAuthRepository repository;

  setUp(() {
    dataSource = FakeFirebaseAuthDataSource();
    repository = FirebaseAuthRepository(dataSource);
  });

  group('signInWithEmail', () {
    test('normalizes the email before calling the provider', () async {
      await repository.signInWithEmail(
        email: '  User@Movies.App ',
        password: 'password1',
      );

      expect(dataSource.lastEmail, 'user@movies.app');
      expect(dataSource.lastPassword, 'password1');
    });

    test('translates provider errors into AuthFailure', () async {
      dataSource.errorToThrow = FirebaseException(
        plugin: 'firebase_auth',
        code: 'invalid-credential',
        message: 'test',
      );

      await expectLater(
        repository.signInWithEmail(email: 'user@movies.app', password: 'x'),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.type,
            'type',
            AuthFailureType.invalidCredentials,
          ),
        ),
      );
    });

    test('maps unexpected errors to an unknown failure', () async {
      dataSource.errorToThrow = StateError('boom');

      await expectLater(
        repository.signInWithEmail(email: 'user@movies.app', password: 'x'),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.type,
            'type',
            AuthFailureType.unknown,
          ),
        ),
      );
    });
  });

  group('registerWithEmail', () {
    test(
      'creates the account, stores the name and sends the verification email',
      () async {
        await repository.registerWithEmail(
          name: '  Mona  ',
          email: 'New@Movies.App',
          password: 'password1',
        );

        expect(dataSource.calls, [
          'createUser',
          'updateDisplayName',
          'sendEmailVerification',
        ]);
        expect(dataSource.lastEmail, 'new@movies.app');
        expect(dataSource.lastDisplayName, 'Mona');
      },
    );

    test('translates an already used email', () async {
      dataSource.errorToThrow = FirebaseException(
        plugin: 'firebase_auth',
        code: 'email-already-in-use',
      );

      await expectLater(
        repository.registerWithEmail(
          name: 'Mona',
          email: 'user@movies.app',
          password: 'password1',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.type,
            'type',
            AuthFailureType.emailAlreadyInUse,
          ),
        ),
      );
    });
  });

  test('sendPasswordResetEmail normalizes the email', () async {
    await repository.sendPasswordResetEmail(' User@Movies.App ');

    expect(dataSource.lastEmail, 'user@movies.app');
  });

  test('sendEmailVerification delegates to the provider', () async {
    await repository.sendEmailVerification();

    expect(dataSource.calls, ['sendEmailVerification']);
  });

  test('reloadCurrentUser maps the refreshed profile', () async {
    dataSource.reloadedUser = dataSource.user;

    final user = await repository.reloadCurrentUser();

    expect(user?.uid, 'uid-1');
  });

  test(
    'reauthenticateWithPassword forwards the password only to the provider',
    () async {
      await repository.reauthenticateWithPassword('password1');

      expect(dataSource.lastPassword, 'password1');
    },
  );

  test('deleteAccount delegates to the provider', () async {
    await repository.deleteAccount();

    expect(dataSource.calls, ['deleteAccount']);
  });

  test('signOut delegates to the provider', () async {
    await repository.signOut();

    expect(dataSource.calls, ['signOut']);
  });
}
