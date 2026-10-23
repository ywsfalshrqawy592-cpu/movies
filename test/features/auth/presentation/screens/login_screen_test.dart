import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/screens/reset_password/reset_password_screen.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/screens/auth/auth_gate.dart';
import 'package:movies_app/Ui/screens/auth/login_screen.dart';
import 'package:movies_app/Ui/screens/auth/register_screen.dart';
import 'package:movies_app/Ui/widgets/auth/auth_form_message.dart';

import '../../../../helpers/pump_app.dart';
import '../../fakes/fake_auth_service.dart';

void main() {
  late FakeAuthService repository;

  setUp(() => repository = FakeAuthService());
  tearDown(() => repository.dispose());

  Future<void> enterCredentials(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    await tester.enterText(find.byType(TextFormField).at(0), email);
    await tester.enterText(find.byType(TextFormField).at(1), password);
  }

  testWidgets('shows the login screen when no user is signed in', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);

    expect(find.byType(AuthGate), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('validates the empty fields without calling the provider', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);

    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(find.text('Please enter your email.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);
    expect(repository.signInCalls, 0);
  });

  testWidgets('rejects a malformed email without calling the provider', (
    tester,
  ) async {
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'not-an-email',
      password: 'password1',
    );
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(find.text('Please enter a valid email address.'), findsOneWidget);
    expect(repository.signInCalls, 0);
  });

  testWidgets('shows a clear message for wrong credentials', (tester) async {
    repository.signInFailure = const AuthFailure(
      AuthFailureType.invalidCredentials,
      cause: 'wrong-password',
    );
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'user@movies.app',
      password: 'nope1234',
    );
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(find.byType(AuthFormMessage), findsOneWidget);
    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(repository.lastSignInEmail, 'user@movies.app');
  });

  testWidgets('treats a missing account like a wrong password', (tester) async {
    // `user-not-found` is the code Firebase returns when no account exists.
    // The UI must not tell the attacker which of the two cases it was.
    repository.signInFailure = const AuthFailure(
      AuthFailureType.invalidCredentials,
      cause: 'user-not-found',
    );
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'missing@movies.app',
      password: 'password1',
    );
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.textContaining('user-not-found'), findsNothing);
    // The spinner stopped and the form accepts a new attempt.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(repository.signInCalls, 2);
  });

  testWidgets('reports rate limiting with a retryable message', (tester) async {
    repository.signInFailure = const AuthFailure(
      AuthFailureType.tooManyRequests,
    );
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'user@movies.app',
      password: 'password1',
    );
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(
      find.text('Too many attempts. Please try again later.'),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // The block comes from the provider, so a later retry is allowed.
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(repository.signInCalls, 2);
  });

  testWidgets('explains when the sign-in method is disabled', (tester) async {
    // This is what the user sees while Email/Password is not enabled in the
    // Firebase console, instead of a raw provider error.
    repository.signInFailure = const AuthFailure(
      AuthFailureType.operationNotAllowed,
    );
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'user@movies.app',
      password: 'password1',
    );
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(
      find.text('This sign-in method is not available right now.'),
      findsOneWidget,
    );
  });

  testWidgets('shows the offline message when the network is down', (
    tester,
  ) async {
    repository.signInFailure = const AuthFailure(AuthFailureType.networkError);
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'user@movies.app',
      password: 'password1',
    );
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(
      find.text('No internet connection. Check your network and try again.'),
      findsOneWidget,
    );
  });

  testWidgets('shows a loading state and ignores double taps', (tester) async {
    repository.pendingSignIn = Completer<void>();
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'user@movies.app',
      password: 'password1',
    );
    await tester.tap(buttonWithText('Login'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repository.signInCalls, 1);

    // While the request is in flight the label is replaced by the spinner, so
    // the second tap targets the button itself.
    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();

    expect(repository.signInCalls, 1);

    repository.pendingSignIn!.complete();
    await pumpFrames(tester);
  });

  testWidgets('opens the registration screen', (tester) async {
    await pumpAuthApp(tester, repository);

    await tester.tap(find.widgetWithText(TextButton, 'Sign up'));
    await pumpFrames(tester);

    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('opens the password reset screen', (tester) async {
    await pumpAuthApp(tester, repository);

    await tester.tap(find.widgetWithText(TextButton, 'Forgot password?'));
    await pumpFrames(tester);

    expect(find.byType(ResetPasswordScreen), findsOneWidget);
  });

  testWidgets('switches to the home screen when a verified user signs in', (
    tester,
  ) async {
    repository.signInUser = const AppUser(
      uid: 'uid-1',
      email: 'user@movies.app',
      emailVerified: true,
    );
    await pumpAuthApp(tester, repository);

    await enterCredentials(
      tester,
      email: 'user@movies.app',
      password: 'password1',
    );
    await tester.tap(buttonWithText('Login'));
    await pumpFrames(tester);

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });
}
