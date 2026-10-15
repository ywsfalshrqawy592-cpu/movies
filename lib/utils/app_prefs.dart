import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static late SharedPreferences _prefs;
  static const _onboardingKey = 'onboarding_seen';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get onboardingSeen => _prefs.getBool(_onboardingKey) ?? false;

  static Future<void> setOnboardingSeen() =>
      _prefs.setBool(_onboardingKey, true);
}