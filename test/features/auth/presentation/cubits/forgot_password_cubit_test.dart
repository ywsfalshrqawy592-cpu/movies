import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/usecases/send_password_reset_email.dart';
import 'package:movies_app/features/auth/presentation/cubits/forgot_password/forgot_password_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubits/forgot_password/forgot_password_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late ForgotPasswordCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = ForgotPasswordCubit(
      sendPasswordResetEmail: SendPasswordResetEmail(repository),
    );
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
