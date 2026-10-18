import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/entities/app_user.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/usecases/reload_auth_user.dart';
import 'package:movies_app/features/auth/domain/usecases/sign_out.dart';
import 'package:movies_app/features/auth/domain/usecases/watch_auth_state.dart';
import 'package:movies_app/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubits/auth/auth_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  const verifiedUser = AppUser(
    uid: 'uid-1',
    email: 'user@movies.app',
    emailVerified: true,
  );
  const unverifiedUser = AppUser(
    uid: 'uid-2',
    email: 'new@movies.app',
    emailVerified: false,
  );

  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());

  tearDown(() => repository.dispose());

  AuthCubit buildCubit({bool requireEmailVerification = true}) => AuthCubit(
    watchAuthState: WatchAuthState(repository),
    reloadAuthUser: ReloadAuthUser(repository),
    signOut: SignOut(repository),
    requireEmailVerification: requireEmailVerification,
  );

  test('starts in the unknown state while the session is restored', () {
    final cubit = buildCubit();
    expect(cubit.state.status, AuthStatus.unknown);
    expect(cubit.state.isSignedIn, isFalse);
    return cubit.close();
  });

  test('becomes unauthenticated when the restored session is empty', () async {
    final cubit = buildCubit();

    await pumpEventQueue();

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.user, isNull);
    await cubit.close();
  });

  test('becomes authenticated when the restored user is verified', () async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    final cubit = buildCubit();

    await pumpEventQueue();

    expect(cubit.state.status, AuthStatus.authenticated);
    expect(cubit.state.user, verifiedUser);
    await cubit.close();
  });

  test('requires the email verification by default', () async {
    repository = FakeAuthRepository(initialUser: unverifiedUser);
    final cubit = buildCubit();

    await pumpEventQueue();

    expect(cubit.state.status, AuthStatus.emailNotVerified);
    expect(cubit.state.isEmailVerified, isFalse);
    await cubit.close();
  });

  test('can accept unverified users when the policy allows it', () async {
    repository = FakeAuthRepository(initialUser: unverifiedUser);
    final cubit = buildCubit(requireEmailVerification: false);

    await pumpEventQueue();

    expect(cubit.state.status, AuthStatus.authenticated);
    await cubit.close();
  });

  test('refreshUser reports that the email is verified', () async {
    repository = FakeAuthRepository(initialUser: unverifiedUser);
    repository.reloadUser = verifiedUser;
    final cubit = buildCubit();
    await pumpEventQueue();

    final verified = await cubit.refreshUser();

    expect(verified, isTrue);
    expect(cubit.state.status, AuthStatus.authenticated);
    expect(cubit.state.isRefreshing, isFalse);
    expect(cubit.state.refreshFailure, isNull);
    await cubit.close();
  });

  test('refreshUser reports that the email is still not verified', () async {
    repository = FakeAuthRepository(initialUser: unverifiedUser);
    repository.reloadUser = unverifiedUser;
    final cubit = buildCubit();
    await pumpEventQueue();

    final verified = await cubit.refreshUser();

    expect(verified, isFalse);
    expect(cubit.state.status, AuthStatus.emailNotVerified);
    await cubit.close();
  });

  test('refreshUser reports a failure without changing the session', () async {
    repository = FakeAuthRepository(initialUser: unverifiedUser);
    repository.reloadFailure = const AuthFailure(AuthFailureType.networkError);
    final cubit = buildCubit();
    await pumpEventQueue();

    final verified = await cubit.refreshUser();

    expect(verified, isNull);
    expect(cubit.state.status, AuthStatus.emailNotVerified);
    expect(cubit.state.isRefreshing, isFalse);
    // The exact reason is kept so the UI can show the real message.
    expect(cubit.state.refreshFailure?.type, AuthFailureType.networkError);
    await cubit.close();
  });

  test('signOut ends the session through the repository', () async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    final cubit = buildCubit();
    await pumpEventQueue();

    await cubit.signOut();
    await pumpEventQueue();

    expect(repository.signOutCalls, 1);
    expect(cubit.state.status, AuthStatus.unauthenticated);
    await cubit.close();
  });

  test('signOut forwards the failure to the caller', () async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    repository.signOutFailure = const AuthFailure(AuthFailureType.networkError);
    final cubit = buildCubit();
    await pumpEventQueue();

    await expectLater(cubit.signOut(), throwsA(isA<AuthFailure>()));

    expect(cubit.state.status, AuthStatus.authenticated);
    await cubit.close();
  });
}
