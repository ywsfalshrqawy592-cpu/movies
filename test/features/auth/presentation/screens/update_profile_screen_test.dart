import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';
import 'package:movies_app/Ui/screens/update_profile/update_profile_screen.dart';
import 'package:movies_app/utils/app_prefs.dart';

import '../../../../helpers/pump_app.dart';
import '../../fakes/fake_auth_service.dart';

void main() {
  const verifiedUser = AppUser(
    uid: 'uid-1',
    email: 'user@movies.app',
    displayName: 'Test User',
    photoUrl: 'assets/images/avatar2.png',
    emailVerified: true,
  );

  late FakeAuthService service;

  setUp(() => service = FakeAuthService(initialUser: verifiedUser));
  tearDown(() => service.dispose());

  Future<void> openProfile(WidgetTester tester) async {
    await pumpAuthApp(tester, service, profilePhone: '01000000000');
    await tester.tap(find.byIcon(Icons.person_outline));
    await pumpFrames(tester);
  }

  Finder fields() => find.descendant(
    of: find.byType(UpdateProfileScreen),
    matching: find.byType(TextFormField),
  );

  testWidgets('prefills the profile from the provider and local prefs', (
    tester,
  ) async {
    await openProfile(tester);

    final nameField = tester.widget<TextFormField>(fields().at(0));
    final phoneField = tester.widget<TextFormField>(fields().at(1));

    expect(nameField.controller?.text, 'Test User');
    expect(phoneField.controller?.text, '01000000000');
    expect(find.text('John Safwat'), findsNothing);
    expect(find.text('01200000000'), findsNothing);
  });

  testWidgets('updates the name, avatar and phone and shows success', (
    tester,
  ) async {
    await openProfile(tester);

    await tester.enterText(fields().at(0), '  Updated User  ');
    await tester.enterText(fields().at(1), '01111111111');
    await tapButton(tester, 'Update Data');
    await pumpFrames(tester);

    expect(service.updateProfileCalls, 1);
    expect(service.lastUpdatedName, '  Updated User  ');
    expect(service.lastUpdatedPhotoUrl, 'assets/images/avatar2.png');
    expect(AppPrefs.profilePhone, '01111111111');
    expect(find.text('Your profile has been updated.'), findsOneWidget);
  });

  testWidgets('lets the user pick a different avatar', (tester) async {
    await openProfile(tester);

    await tester.tap(find.byType(CircleAvatar));
    await pumpFrames(tester);
    expect(find.byType(GridView), findsOneWidget);

    final avatars = find.descendant(
      of: find.byType(GridView),
      matching: find.byType(Image),
    );
    await tester.tap(avatars.at(2));
    await pumpFrames(tester);
    await tapButton(tester, 'Update Data');
    await pumpFrames(tester);

    expect(service.lastUpdatedPhotoUrl, 'assets/images/avatar3.png');
  });

  testWidgets('validates the name before calling the provider', (tester) async {
    await openProfile(tester);

    await tester.enterText(fields().at(0), '   ');
    await tapButton(tester, 'Update Data');
    await pumpFrames(tester);

    expect(find.text('Please enter your name.'), findsOneWidget);
    expect(service.updateProfileCalls, 0);
  });

  testWidgets('rejects an invalid phone number', (tester) async {
    await openProfile(tester);

    await tester.enterText(fields().at(1), 'not-a-phone');
    await tapButton(tester, 'Update Data');
    await pumpFrames(tester);

    expect(find.text('Please enter a valid phone number.'), findsOneWidget);
    expect(service.updateProfileCalls, 0);
  });

  testWidgets('shows a clear error when the provider fails', (tester) async {
    service.updateProfileFailure = const AuthFailure(
      AuthFailureType.networkError,
    );
    await openProfile(tester);

    await tester.enterText(fields().at(0), 'Updated User');
    await tapButton(tester, 'Update Data');
    await pumpFrames(tester);

    expect(
      find.text('No internet connection. Check your network and try again.'),
      findsOneWidget,
    );
    expect(find.text('Your profile has been updated.'), findsNothing);
  });

  testWidgets('shows a loading state and ignores double taps', (tester) async {
    service.pendingUpdate = Completer<void>();
    await openProfile(tester);

    await tester.enterText(fields().at(0), 'Updated User');
    await tapButton(tester, 'Update Data');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(service.updateProfileCalls, 1);

    await tester.tap(
      find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(ElevatedButton),
      ),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(service.updateProfileCalls, 1);

    service.pendingUpdate!.complete();
    await pumpFrames(tester);
  });
}
