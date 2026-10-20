import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/cubits/register_cubit.dart';

import '../../fakes/fake_auth_service.dart';

void main() {
  late FakeAuthService repository;
  late RegisterCubit cubit;

  setUp(() {
    repository = FakeAuthService();
    cubit = RegisterCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('creates the account and keeps it unverified', () async {
    await cubit.submit(
      name: 'New User',
      email: 'new@movies.app',
      password: 'password1',
    );

    expect(cubit.state.status, RegisterStatus.success);
    expect(cubit.state.user?.emailVerified, isFalse);
    expect(repository.lastRegisteredName, 'New User');
    expect(repository.lastRegisteredEmail, 'new@movies.app');
  });

  test('reports an already registered email', () async {
    repository.registerFailure = const AuthFailure(
      AuthFailureType.emailAlreadyInUse,
    );

    await cubit.submit(
      name: 'New User',
      email: 'new@movies.app',
      password: 'password1',
    );

    expect(cubit.state.status, RegisterStatus.failure);
    expect(cubit.state.failure?.type, AuthFailureType.emailAlreadyInUse);
  });

  test('reports a weak password rejected by the provider', () async {
    repository.registerFailure = const AuthFailure(
      AuthFailureType.weakPassword,
    );

    await cubit.submit(
      name: 'New User',
      email: 'new@movies.app',
      password: 'password1',
    );

    expect(cubit.state.failure?.type, AuthFailureType.weakPassword);
  });

  test('emits a submitting state while the request is running', () async {
    repository.pendingRegister = Completer<void>();

    final request = cubit.submit(
      name: 'New User',
      email: 'new@movies.app',
      password: 'password1',
    );

    expect(cubit.state.isSubmitting, isTrue);

    repository.pendingRegister!.complete();
    await request;

    expect(cubit.state.isSuccess, isTrue);
  });

  test('ignores repeated submissions while a request is running', () async {
    repository.pendingRegister = Completer<void>();

    final first = cubit.submit(
      name: 'New User',
      email: 'new@movies.app',
      password: 'password1',
    );
    await cubit.submit(
      name: 'New User',
      email: 'new@movies.app',
      password: 'password1',
    );

    expect(repository.registerCalls, 1);

    repository.pendingRegister!.complete();
    await first;

    expect(repository.registerCalls, 1);
  });
}
