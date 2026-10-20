import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/screens/auth/email_verification_screen.dart';
import 'package:movies_app/Ui/screens/auth/login_screen.dart';

import '../../../../helpers/pump_app.dart';
import '../../fakes/fake_auth_service.dart';

void main() {
  const unverifiedUser = AppUser(
    uid: 'uid-1',
    email: 'user@movies.app',
    emailVerified: false,
  );

  late FakeAuthService repository;

  setUp(() {
    repository = FakeAuthService(initialUser: unverifiedUser)
      ..reloadUser = unverifiedUser;
  });

  tearDown(() => repository.dispose());

  testWidgets('shows the email and the resend action', (tester) async {
    await pumpAuthApp(tester, repository);

    expect(find.byType(EmailVerificationScreen), findsOneWidget);
    expect(find.textContaining('user@movies.app'), findsOneWidget);
    expect(find.text('Resend email'), findsOneWidget);
    expect(find.text('I verified my email'), findsOneWidget);
  });

  testWidgets('resends the verification email and starts the cooldown', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);

    await tester.tap(buttonWithText('Resend email'));
    await pumpFrames(tester);

    expect(repository.sendEmailVerificationCalls, 1);
    expect(find.text('Verification email sent.'), findsOneWidget);
    expect(find.textContaining('Resend in'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('blocks the resend when the provider rate limits', (
    tester,
  ) async {
    repository.sendEmailVerificationFailure = const AuthFailure(
      AuthFailureType.tooManyRequests,
    );
    await pumpAuthApp(tester, repository);

    await tester.tap(buttonWithText('Resend email'));
    await pumpFrames(tester);

    expect(
      find.text('Too many attempts. Please try again later.'),
      findsOneWidget,
    );

    await disposeApp(tester);
  });

  testWidgets('stays on the screen while the provider says unverified', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);

    await tester.tap(buttonWithText('I verified my email'));
    await pumpFrames(tester);

    expect(repository.reloadCurrentUserCalls, 1);
    expect(
      find.text(
        'Your email is not verified yet. Open the link we sent you, then try again.',
      ),
      findsOneWidget,
    );
    expect(find.byType(EmailVerificationScreen), findsOneWidget);
  });

  testWidgets('moves to the home screen once the provider confirms', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);
    repository.reloadUser = const AppUser(
      uid: 'uid-1',
      email: 'user@movies.app',
      emailVerified: true,
    );

    await tester.tap(buttonWithText('I verified my email'));
    await pumpFrames(tester);

    expect(find.byType(EmailVerificationScreen), findsNothing);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  testWidgets('stays usable when the verification check is offline', (
    tester,
  ) async {
    repository.reloadFailure = const AuthFailure(AuthFailureType.networkError);
    await pumpAuthApp(tester, repository);

    await tester.tap(buttonWithText('I verified my email'));
    await pumpFrames(tester);

    expect(
      find.text('No internet connection. Check your network and try again.'),
      findsOneWidget,
    );
    // The screen is still there and no false success is shown.
    expect(find.byType(EmailVerificationScreen), findsOneWidget);
  });

  testWidgets('reloads the profile when the app comes back to the foreground', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);

    // The verification link is opened in the browser / mail app, so the app
    // has to re-check the provider profile when it is resumed.
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/lifecycle',
      const StringCodec().encodeMessage('AppLifecycleState.inactive'),
      (_) {},
    );
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/lifecycle',
      const StringCodec().encodeMessage('AppLifecycleState.resumed'),
      (_) {},
    );
    await pumpFrames(tester);

    expect(repository.reloadCurrentUserCalls, 1);
  });

  testWidgets('uses another account by signing out', (tester) async {
    await pumpAuthApp(tester, repository);

    await tester.tap(find.widgetWithText(TextButton, 'Use another account'));
    await pumpFrames(tester);

    expect(repository.signOutCalls, 1);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
