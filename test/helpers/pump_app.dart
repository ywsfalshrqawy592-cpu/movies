import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/language/language_cubit.dart';
import 'package:movies_app/features/auth/auth_scope.dart';
import 'package:movies_app/main.dart';
import 'package:movies_app/utils/app_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/fakes/fake_auth_repository.dart';

/// Pumps the real app (same providers and routes as `main.dart`) on top of a
/// fake authentication repository, so widget tests never touch Firebase.
Future<void> pumpAuthApp(
  WidgetTester tester,
  FakeAuthRepository repository, {
  bool onboardingSeen = true,
  String languageCode = 'en',
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_seen': onboardingSeen,
    'language_code': languageCode,
  });
  await AppPrefs.init();

  await tester.pumpWidget(
    BlocProvider(
      create: (_) => LanguageCubit(),
      child: AuthScope(repository: repository, child: const MyApp()),
    ),
  );
  await pumpFrames(tester);
}

/// Pumps a few frames without waiting for animations to finish.
///
/// `pumpAndSettle` cannot be used while a progress indicator is on screen
/// (its animation never ends), so the tests advance the clock explicitly.
/// The third frame lets the navigator finish its bookkeeping after a route
/// transition (a pushed route takes the previous one off stage and a popped
/// route is only disposed on the frame that follows the end of the animation).
Future<void> pumpFrames(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 400),
}) async {
  await tester.pump();
  await tester.pump(duration);
  await tester.pump(duration);
}

/// Disposes the widget tree so cubits release their timers and streams.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

/// Finds the button of the authentication forms by its label.
Finder buttonWithText(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(ElevatedButton));

/// Scrolls the form button [label] into view and taps it.
///
/// The submit buttons live at the bottom of the scrolling forms and are below
/// the 800x600 test surface, so they have to be brought into view first.
Future<void> tapButton(WidgetTester tester, String label) async {
  final finder = buttonWithText(label);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
}
