// Firebase options of the `movies-app-3cb31` Firebase project.
//
// The Android, iOS and macOS values were taken from the configuration files
// that the Firebase console generated for this repository:
//   * android/app/google-services.json
//   * ios/Runner/GoogleService-Info.plist
//   * macos/Runner/GoogleService-Info.plist
//
// The Web configuration (apiKey / authDomain / measurementId) is not present in
// the repository yet, so Web / Windows / Linux are reported as unsupported until
// somebody with access to the Firebase project runs:
//
//   flutterfire configure --project=movies-app-3cb31 --platforms=android,ios,macos,web,windows
//
// That command regenerates this file with the missing values.
//
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for the platform the app is running on.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(_missingOptionsMessage('Web'));
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(_missingOptionsMessage('Windows'));
      case TargetPlatform.linux:
        throw UnsupportedError(_missingOptionsMessage('Linux'));
      case TargetPlatform.fuchsia:
        throw UnsupportedError(_missingOptionsMessage('Fuchsia'));
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAVF43Ph2irP6lTHRPUpT2C83q99rFlRM',
    appId: '1:162955125929:android:3b68dffd6e406ad9dcb5b8',
    messagingSenderId: '162955125929',
    projectId: 'movies-app-3cb31',
    storageBucket: 'movies-app-3cb31.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCU23d1uyxyFaDd0k7P5HEI6PwIApzICPY',
    appId: '1:162955125929:ios:2b77b186601a4a60dcb5b8',
    messagingSenderId: '162955125929',
    projectId: 'movies-app-3cb31',
    storageBucket: 'movies-app-3cb31.firebasestorage.app',
    iosBundleId: 'com.example.moviesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCU23d1uyxyFaDd0k7P5HEI6PwIApzICPY',
    appId: '1:162955125929:ios:2b77b186601a4a60dcb5b8',
    messagingSenderId: '162955125929',
    projectId: 'movies-app-3cb31',
    storageBucket: 'movies-app-3cb31.firebasestorage.app',
    iosBundleId: 'com.example.moviesApp',
  );

  static String _missingOptionsMessage(String platform) =>
      'DefaultFirebaseOptions are not configured for $platform yet. '
      'Run `flutterfire configure --project=movies-app-3cb31` with an account '
      'that has access to the Firebase project to add them.';
}
