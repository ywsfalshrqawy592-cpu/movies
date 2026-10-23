# Movies App

A Flutter movie discovery app with Firebase email authentication, Arabic and
English localization, onboarding, and a movie home screen.

## Requirements

- Flutter SDK matching the Dart constraint in `pubspec.yaml`.
- A configured Firebase project for Android, iOS, or macOS.
- Firebase Authentication with Email/Password enabled.

## Run locally

```sh
flutter pub get
flutter run
```

Firebase configuration is stored in the native platform files and
`lib/firebase_options.dart`. Web, Windows, and Linux are not configured in the
Dart Firebase options yet.

## Localization

English and Arabic strings live in `lib/l10n/app_en.arb` and
`lib/l10n/app_ar.arb`. After editing either file, regenerate the localization
classes with:

```sh
flutter gen-l10n
```

The language control is available in onboarding, authentication screens, the
home screen, and profile editing.

## Source layout

- `lib/Ui/auth`: Firebase auth service, user model, validation, and error mapping.
- `lib/cubit`: authentication and screen state management.
- `lib/Ui/screens`: onboarding, authentication, profile, and movie screens.
- `lib/Ui/widgets`: shared UI components.
- `lib/utils`: routes, styles, colors, assets, and preferences.
- `test/auth_validators_test.dart`: basic email and password validation tests.

See [docs/AUTHENTICATION.md](docs/AUTHENTICATION.md) for the auth flow and
Firebase setup notes.
