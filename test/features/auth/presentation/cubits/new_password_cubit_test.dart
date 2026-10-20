import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/cubits/new_password_cubit.dart';

import '../../fakes/fake_auth_service.dart';

void main() {
  late FakeAuthService service;

  setUp(() => service = FakeAuthService());
  tearDown(() => service.dispose());

  test('verifies the reset code and exposes its email', () async {
    final cubit = NewPasswordCubit(service, 'valid-code');
    addTearDown(cubit.close);

    expect(cubit.state.isVerifying, isTrue);
    await pumpEventQueue();

    expect(cubit.state.isReady, isTrue);
    expect(cubit.state.email, 'user@movies.app');
    expect(service.lastResetCode, 'valid-code');
  });

  test('rejects an empty reset code without calling the provider', () async {
    final cubit = NewPasswordCubit(service, '  ');
    addTearDown(cubit.close);

    await pumpEventQueue();

    expect(cubit.state.hasInvalidLink, isTrue);
    expect(cubit.state.failure?.type, AuthFailureType.invalidActionCode);
    expect(service.verifyResetCodeCalls, 0);
  });

  test('reports an expired or invalid link', () async {
    service.verifyResetCodeFailure = const AuthFailure(
      AuthFailureType.invalidActionCode,
    );
    final cubit = NewPasswordCubit(service, 'expired-code');
    addTearDown(cubit.close);

    await pumpEventQueue();

    expect(cubit.state.hasInvalidLink, isTrue);
    expect(cubit.state.failure?.type, AuthFailureType.invalidActionCode);
  });

  test('saves the new password for a valid code', () async {
    final cubit = NewPasswordCubit(service, 'valid-code');
    addTearDown(cubit.close);
    await pumpEventQueue();

    await cubit.submit('password2');

    expect(cubit.state.isSuccess, isTrue);
    expect(service.confirmPasswordResetCalls, 1);
    expect(service.lastConfirmedResetCode, 'valid-code');
    expect(service.lastConfirmedNewPassword, 'password2');
  });

  test('reports a failure when saving the password fails', () async {
    final cubit = NewPasswordCubit(service, 'valid-code');
    addTearDown(cubit.close);
    await pumpEventQueue();

    service.confirmPasswordResetFailure = const AuthFailure(
      AuthFailureType.networkError,
    );
    await cubit.submit('password2');

    expect(cubit.state.hasFailed, isTrue);
    expect(cubit.state.failure?.type, AuthFailureType.networkError);
  });

  test('ignores a second submit while the first one is running', () async {
    final cubit = NewPasswordCubit(service, 'valid-code');
    addTearDown(cubit.close);
    await pumpEventQueue();

    service.pendingConfirmReset = Completer<void>();
    final first = cubit.submit('password2');
    await cubit.submit('password3');

    expect(service.confirmPasswordResetCalls, 1);

    service.pendingConfirmReset!.complete();
    await first;
    expect(cubit.state.isSuccess, isTrue);
  });
}
