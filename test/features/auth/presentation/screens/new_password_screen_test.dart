import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/screens/auth/login_screen.dart';
import 'package:movies_app/Ui/screens/auth/new_password_screen.dart';
import 'package:movies_app/utils/app_routes.dart';

import '../../../../helpers/pump_app.dart';
import '../../fakes/fake_auth_service.dart';

void main() {
  late FakeAuthService service;

  setUp(() => service = FakeAuthService());
  tearDown(() => service.dispose());

  Future<void> openNewPassword(WidgetTester tester, String code) async {
    await pumpAuthApp(tester, service);
    final context = tester.element(find.byType(LoginScreen));
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.newPasswordRouteName, arguments: code);
    await pumpFrames(tester);
  }

  Finder passwordFields() => find.descendant(
    of: find.byType(NewPasswordScreen),
    matching: find.byType(TextFormField),
  );

  testWidgets('verifies the link and shows the new password form', (
    tester,
  ) async {
    await openNewPassword(tester, 'valid-code');

    expect(find.byType(NewPasswordScreen), findsOneWidget);
    expect(find.text('Set a new password'), findsWidgets);
    expect(
      find.text('Choose a new password for user@movies.app.'),
      findsOneWidget,
    );
    expect(service.lastResetCode, 'valid-code');
  });

  testWidgets('rejects an expired link with a clear message', (tester) async {
    service.verifyResetCodeFailure = const AuthFailure(
      AuthFailureType.invalidActionCode,
    );
    await openNewPassword(tester, 'expired-code');

    expect(
      find.text(
        'This reset link is invalid or has expired. Please request a new one.',
      ),
      findsOneWidget,
    );
    expect(passwordFields(), findsNothing);
    expect(find.text('Request a new reset link'), findsOneWidget);
  });

  testWidgets('validates the new password and its confirmation', (
    tester,
  ) async {
    await openNewPassword(tester, 'valid-code');

    await tester.enterText(passwordFields().at(0), 'password1');
    await tester.enterText(passwordFields().at(1), 'password2');
    await tapButton(tester, 'Save new password');
    await pumpFrames(tester);

    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(service.confirmPasswordResetCalls, 0);
  });

  testWidgets('keeps the form and shows an error when saving fails', (
    tester,
  ) async {
    await openNewPassword(tester, 'valid-code');
    service.confirmPasswordResetFailure = const AuthFailure(
      AuthFailureType.networkError,
    );

    await tester.enterText(passwordFields().at(0), 'password2');
    await tester.enterText(passwordFields().at(1), 'password2');
    await tapButton(tester, 'Save new password');
    await pumpFrames(tester);

    expect(
      find.text('No internet connection. Check your network and try again.'),
      findsOneWidget,
    );
    expect(passwordFields(), findsNWidgets(2));
    expect(find.text('Save new password'), findsOneWidget);
    expect(service.confirmPasswordResetCalls, 1);
  });

  testWidgets('saves the password and returns the user to the login screen', (
    tester,
  ) async {
    await openNewPassword(tester, 'valid-code');

    await tester.enterText(passwordFields().at(0), 'password2');
    await tester.enterText(passwordFields().at(1), 'password2');
    await tapButton(tester, 'Save new password');
    await pumpFrames(tester);

    expect(service.confirmPasswordResetCalls, 1);
    expect(service.lastConfirmedNewPassword, 'password2');
    expect(
      find.text(
        'Your password has been updated. Sign in with your new password.',
      ),
      findsOneWidget,
    );

    await tester.tap(buttonWithText('Back to sign in'));
    await pumpFrames(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(NewPasswordScreen), findsNothing);
  });
}
