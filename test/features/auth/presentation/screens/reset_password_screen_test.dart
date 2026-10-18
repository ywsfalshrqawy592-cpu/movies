import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/screens/reset_password/reset_password_screen.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';

import '../../../../helpers/pump_app.dart';
import '../../fakes/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());
  tearDown(() => repository.dispose());

  Future<void> openScreen(WidgetTester tester) async {
    await pumpAuthApp(tester, repository);
    await tester.tap(find.widgetWithText(TextButton, 'Forgot password?'));
    await pumpFrames(tester);
  }

  /// The login screen stays below this one in the navigator, so the field is
  /// looked up inside the reset password screen only.
  Finder emailField() => find.descendant(
    of: find.byType(ResetPasswordScreen),
    matching: find.byType(TextFormField),
  );

  testWidgets('validates the email before sending anything', (tester) async {
    await openScreen(tester);

    await tester.enterText(emailField(), 'not-an-email');
    await tapButton(tester, 'Send reset link');
    await pumpFrames(tester);

    expect(find.text('Please enter a valid email address.'), findsOneWidget);
    expect(repository.sendPasswordResetEmailCalls, 0);
    expect(find.byType(ResetPasswordScreen), findsOneWidget);
  });

  testWidgets('shows a neutral confirmation after a successful request', (
    tester,
  ) async {
    await openScreen(tester);

    await tester.enterText(emailField(), '  Unknown@Movies.App ');
    await tapButton(tester, 'Send reset link');
    await pumpFrames(tester);

    expect(repository.sendPasswordResetEmailCalls, 1);
    expect(repository.lastPasswordResetEmail, '  Unknown@Movies.App ');
    expect(
      find.text(
        'If an account exists for this email, a reset link has been sent. Check your inbox.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('reports provider failures', (tester) async {
    repository.sendPasswordResetEmailFailure = const AuthFailure(
      AuthFailureType.networkError,
    );
    await openScreen(tester);

    await tester.enterText(emailField(), 'user@movies.app');
    await tapButton(tester, 'Send reset link');
    await pumpFrames(tester);

    expect(
      find.text('No internet connection. Check your network and try again.'),
      findsOneWidget,
    );
    // A failed request must never look like a sent email.
    expect(find.textContaining('reset link has been sent'), findsNothing);
  });
}
