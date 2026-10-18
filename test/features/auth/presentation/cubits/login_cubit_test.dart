import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:movies_app/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubits/login/login_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late LoginCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = LoginCubit(signInWithEmail: SignInWithEmail(repository));
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('starts idle', () {
    expect(cubit.state.status, LoginStatus.idle);
    expect(cubit.state.hasFailed, isFalse);
  });

  test('signs in successfully', () async {
    await cubit.submit(email: 'user@movies.app', password: 'password1');

    expect(cubit.state.status, LoginStatus.success);
    expect(cubit.state.user, repository.signInUser);
    expect(repository.lastSignInEmail, 'user@movies.app');
  });

  test('reports wrong credentials without revealing the reason', () async {
    repository.signInFailure = const AuthFailure(
      AuthFailureType.invalidCredentials,
      cause: 'wrong-password',
    );

    await cubit.submit(email: 'user@movies.app', password: 'nope1234');

    expect(cubit.state.status, LoginStatus.failure);
    expect(cubit.state.failure?.type, AuthFailureType.invalidCredentials);
  });

  test('reports network failures', () async {
    repository.signInFailure = const AuthFailure(AuthFailureType.networkError);

    await cubit.submit(email: 'user@movies.app', password: 'password1');

    expect(cubit.state.failure?.type, AuthFailureType.networkError);
  });

  test('emits a submitting state while the request is running', () async {
    repository.pendingSignIn = Completer<void>();

    final request = cubit.submit(
      email: 'user@movies.app',
      password: 'password1',
    );

    expect(cubit.state.isSubmitting, isTrue);

    repository.pendingSignIn!.complete();
    await request;

    expect(cubit.state.status, LoginStatus.success);
  });

  test('ignores repeated submissions while a request is running', () async {
    repository.pendingSignIn = Completer<void>();

    final first = cubit.submit(email: 'user@movies.app', password: 'password1');
    await cubit.submit(email: 'user@movies.app', password: 'password1');

    expect(repository.signInCalls, 1);

    repository.pendingSignIn!.complete();
    await first;

    expect(repository.signInCalls, 1);
  });
}
