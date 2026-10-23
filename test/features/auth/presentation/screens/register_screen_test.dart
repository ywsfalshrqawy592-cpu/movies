import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/screens/home/home_screen.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/screens/auth/email_verification_screen.dart';
import 'package:movies_app/Ui/screens/auth/register_screen.dart';

import '../../../../helpers/pump_app.dart';
import '../../fakes/fake_auth_service.dart';

void main() {
  late FakeAuthService repository;

  setUp(() => repository = FakeAuthService());
  tearDown(() => repository.dispose());

  Future<void> openRegistration(WidgetTester tester) async {
    await pumpAuthApp(tester, repository);
    await tester.tap(find.widgetWithText(TextButton, 'Sign up'));
    await pumpFrames(tester);
  }

  Future<void> fillForm(
    WidgetTester tester, {
    required String name,
    required String email,
    required String password,
    required String confirmation,
  }) async {
    final fields = find.descendant(
      of: find.byType(RegisterScreen),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(fields.at(0), name);
    await tester.enterText(fields.at(1), email);
    await tester.enterText(fields.at(2), password);
    await tester.enterText(fields.at(3), confirmation);
  }

  testWidgets('asks for the fields the project requires', (tester) async {
    await openRegistration(tester);

    final fields = find.descendant(
      of: find.byType(RegisterScreen),
      matching: find.byType(TextFormField),
    );
    // Name, email, password and its confirmation. The project has no phone,
    // terms or extra profile requirements for creating an account (the phone
    // field lives only in the profile screen, which needs a database).
    expect(fields, findsNWidgets(4));
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
  });

  testWidgets('requires a name, a valid email and a strong password', (
    tester,
  ) async {
    await openRegistration(tester);

    await tapButton(tester, 'Create account');
    await pumpFrames(tester);

    expect(find.text('Please enter your name.'), findsOneWidget);
    expect(find.text('Please enter your email.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);
    expect(find.text('Please confirm your password.'), findsOneWidget);
    expect(repository.registerCalls, 0);
  });

  testWidgets('reports a weak password and a mismatched confirmation', (
    tester,
  ) async {
    await openRegistration(tester);

    await fillForm(
      tester,
      name: 'New User',
      email: 'new@movies.app',
      password: 'short',
      confirmation: 'different',
    );
    await tapButton(tester, 'Create account');
    await pumpFrames(tester);

    expect(
      find.text('Password must be at least 8 characters.'),
      findsOneWidget,
    );
    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(repository.registerCalls, 0);
  });

  testWidgets('reports an email that is already registered', (tester) async {
    repository.registerFailure = const AuthFailure(
      AuthFailureType.emailAlreadyInUse,
    );
    await openRegistration(tester);

    await fillForm(
      tester,
      name: 'New User',
      email: 'user@movies.app',
      password: 'password1',
      confirmation: 'password1',
    );
    await tapButton(tester, 'Create account');
    await pumpFrames(tester);

    expect(find.text('This email is already registered.'), findsOneWidget);
    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('lands on the verification screen after a successful sign up', (
    tester,
  ) async {
    repository.registerUser = const AppUser(
      uid: 'uid-2',
      email: 'new@movies.app',
      emailVerified: false,
    );
    await openRegistration(tester);

    await fillForm(
      tester,
      name: 'New User',
      email: 'new@movies.app',
      password: 'password1',
      confirmation: 'password1',
    );
    await tapButton(tester, 'Create account');
    await pumpFrames(tester);

    expect(repository.registerCalls, 1);
    expect(repository.lastRegisteredEmail, 'new@movies.app');
    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(EmailVerificationScreen), findsOneWidget);
    // The account exists but the email is not verified, so the home screen
    // stays out of reach.
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.textContaining('new@movies.app'), findsOneWidget);
  });
}
