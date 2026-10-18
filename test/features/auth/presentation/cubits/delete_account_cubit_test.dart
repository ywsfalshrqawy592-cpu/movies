import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/usecases/delete_account.dart';
import 'package:movies_app/features/auth/domain/usecases/reauthenticate_with_password.dart';
import 'package:movies_app/features/auth/presentation/cubits/delete_account/delete_account_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubits/delete_account/delete_account_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late DeleteAccountCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = DeleteAccountCubit(
      reauthenticateWithPassword: ReauthenticateWithPassword(repository),
      deleteAccount: DeleteAccount(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('re-authenticates before deleting the account', () async {
    await cubit.confirmDeletion('password1');

    expect(cubit.state.status, DeleteAccountStatus.success);
    expect(repository.reauthenticateCalls, 1);
    expect(repository.deleteAccountCalls, 1);
    expect(repository.lastReauthenticatedPassword, 'password1');
  });

  test('does not delete anything when the password is wrong', () async {
    repository.reauthenticateFailure = const AuthFailure(
      AuthFailureType.invalidCredentials,
      cause: 'wrong-password',
    );

    await cubit.confirmDeletion('wrong-password');

    expect(cubit.state.status, DeleteAccountStatus.failure);
    expect(cubit.state.failure?.type, AuthFailureType.invalidCredentials);
    expect(repository.deleteAccountCalls, 0);
  });

  test('reports a stale session', () async {
    repository.deleteAccountFailure = const AuthFailure(
      AuthFailureType.requiresRecentLogin,
    );

    await cubit.confirmDeletion('password1');

    expect(cubit.state.failure?.type, AuthFailureType.requiresRecentLogin);
  });

  test('ignores repeated confirmations while a request is running', () async {
    repository.pendingSignIn = Completer<void>();

    final first = cubit.confirmDeletion('password1');
    await cubit.confirmDeletion('password1');

    expect(repository.reauthenticateCalls, 1);

    repository.pendingSignIn!.complete();
    await first;

    expect(repository.deleteAccountCalls, 1);
  });
}
