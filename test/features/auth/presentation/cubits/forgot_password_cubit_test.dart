import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/cubits/forgot_password_cubit.dart';

import '../../fakes/fake_auth_service.dart';

void main() {
  late FakeAuthService repository;
  late ForgotPasswordCubit cubit;

  setUp(() {
    repository = FakeAuthService();
    cubit = ForgotPasswordCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('sends the reset link and reports a neutral success', () async {
    await cubit.submit('user@movies.app');

    expect(cubit.state.status, ForgotPasswordStatus.success);
    expect(cubit.state.hasFailed, isFalse);
    expect(repository.lastPasswordResetEmail, 'user@movies.app');
  });

  test('reports provider failures', () async {
    repository.sendPasswordResetEmailFailure = const AuthFailure(
      AuthFailureType.tooManyRequests,
    );

    await cubit.submit('user@movies.app');

    expect(cubit.state.status, ForgotPasswordStatus.failure);
    expect(cubit.state.failure?.type, AuthFailureType.tooManyRequests);
  });

  test('reports offline failures', () async {
    repository.sendPasswordResetEmailFailure = const AuthFailure(
      AuthFailureType.networkError,
    );

    await cubit.submit('user@movies.app');

    expect(cubit.state.failure?.type, AuthFailureType.networkError);
  });

  test('ignores repeated submissions while a request is running', () async {
    repository.pendingSignIn = Completer<void>();

    final first = cubit.submit('user@movies.app');
    await cubit.submit('user@movies.app');

    expect(repository.sendPasswordResetEmailCalls, 1);

    repository.pendingSignIn!.complete();
    await first;
  });
}
