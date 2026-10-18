import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/screens/home/home_screen.dart';
import 'package:movies_app/Ui/screens/update_profile/update_profile_screen.dart';
import 'package:movies_app/features/auth/domain/entities/app_user.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/screens/auth_gate.dart';
import 'package:movies_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:movies_app/features/auth/presentation/screens/login_screen.dart';
import 'package:movies_app/main.dart';
import 'package:movies_app/utils/app_prefs.dart';

import '../../../helpers/pump_app.dart';
import '../fakes/fake_auth_repository.dart';

void main() {
  const verifiedUser = AppUser(
    uid: 'uid-1',
    email: 'user@movies.app',
    displayName: 'Test User',
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

  testWidgets('wires the repository and the session cubit of the app', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);

    final context = tester.element(find.byType(AuthGate));

    expect(context.read<AuthRepository>(), same(repository));
    expect(context.read<AuthCubit>(), isA<AuthCubit>());
  });

  testWidgets('restores the session of a verified user', (tester) async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    await pumpAuthApp(tester, repository);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('asks an unverified user to verify the email first', (
    tester,
  ) async {
    repository = FakeAuthRepository(initialUser: unverifiedUser)
      ..reloadUser = unverifiedUser;
    await pumpAuthApp(tester, repository);

    expect(find.byType(EmailVerificationScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('signs in and reaches the home screen', (tester) async {
    await pumpAuthApp(tester, repository);

    await tester.enterText(find.byType(TextFormField).at(0), 'user@movies.app');
    await tester.enterText(find.byType(TextFormField).at(1), 'password1');
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets(
    'signs out from the home screen and returns to the login screen',
    (tester) async {
      repository = FakeAuthRepository(initialUser: verifiedUser);
      await pumpAuthApp(tester, repository);

      await tester.tap(find.byIcon(Icons.logout));
      await pumpFrames(tester);
      expect(
        find.text('Do you want to logout from this account?'),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(TextButton, 'Logout'));
      await pumpFrames(tester);

      expect(repository.signOutCalls, 1);
      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  testWidgets('closes a protected screen when the session ends', (
    tester,
  ) async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    await pumpAuthApp(tester, repository);

    await tester.tap(find.byIcon(Icons.person_outline));
    await pumpFrames(tester);
    expect(find.byType(UpdateProfileScreen), findsOneWidget);

    // The session can end anywhere: provider side revocation, sign-out on
    // another device, ... The protected screen must not stay visible.
    await repository.signOut();
    // `pumpAndSettle` is safe here: the login screen that replaces the profile
    // has no endless animation, and it waits for the route disposal that ends
    // the pop transition.
    await tester.pumpAndSettle();

    expect(find.byType(UpdateProfileScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('handles repeated session events without extra navigation', (
    tester,
  ) async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    await pumpAuthApp(tester, repository);

    // Providers can deliver the same state more than once (reconnects, token
    // refresh, ...): the app must stay on a single screen.
    await repository.signOut();
    await repository.signOut();
    await pumpFrames(tester);

    expect(repository.signOutCalls, 2);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(AuthGate), findsOneWidget);
  });

  testWidgets('signing out keeps the data that is not part of the session', (
    tester,
  ) async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    await pumpAuthApp(tester, repository);

    await tester.tap(find.byIcon(Icons.logout));
    await pumpFrames(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Logout'));
    await pumpFrames(tester);

    expect(repository.signOutCalls, 1);
    // The onboarding flag and the language are app preferences, not session
    // data: signing out must not reset them.
    expect(AppPrefs.onboardingSeen, isTrue);
    expect(AppPrefs.languageCode, 'en');
  });

  testWidgets('deletes the account after re-authentication', (tester) async {
    repository = FakeAuthRepository(initialUser: verifiedUser);
    await pumpAuthApp(tester, repository);

    await tester.tap(find.byIcon(Icons.person_outline));
    await pumpFrames(tester);
    await tester.tap(buttonWithText('Delete Account'));
    await pumpFrames(tester);

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextFormField),
      ),
      'password1',
    );
    await tester.tap(buttonWithText('Delete'));
    await pumpFrames(tester);

    expect(repository.reauthenticateCalls, 1);
    expect(repository.deleteAccountCalls, 1);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Your account has been deleted.'), findsOneWidget);
  });

  testWidgets('keeps the account when the password is wrong', (tester) async {
    repository = FakeAuthRepository(initialUser: verifiedUser)
      ..reauthenticateFailure = const AuthFailure(
        AuthFailureType.invalidCredentials,
      );
    await pumpAuthApp(tester, repository);

    await tester.tap(find.byIcon(Icons.person_outline));
    await pumpFrames(tester);
    await tester.tap(buttonWithText('Delete Account'));
    await pumpFrames(tester);

    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextFormField),
      ),
      'wrong-password',
    );
    await tester.tap(buttonWithText('Delete'));
    await pumpFrames(tester);

    expect(repository.deleteAccountCalls, 0);
    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('finishes the onboarding before asking for the credentials', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository, onboardingSeen: false);

    // The onboarding is the first screen of a fresh install.
    expect(find.text('Explore Now'), findsOneWidget);

    await tester.tap(find.text('Explore Now'));
    await pumpFrames(tester);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Next'));
      await pumpFrames(tester);
    }
    await tester.tap(find.text('Finish'));
    await pumpFrames(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('renders the app with the Arabic locale', (tester) async {
    await pumpAuthApp(tester, repository, languageCode: 'ar');

    expect(find.byType(MyApp), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.byType(LoginScreen))),
      TextDirection.rtl,
    );
  });
}
