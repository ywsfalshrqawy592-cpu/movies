import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static late SharedPreferences _prefs;
  static const _onboardingKey = 'onboarding_seen';
  static const _languageKey = 'language_code';
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get onboardingSeen => _prefs.getBool(_onboardingKey) ?? false;
  static String get languageCode => _prefs.getString(_languageKey) ?? 'en';

  static Future<void> setOnboardingSeen() =>
      _prefs.setBool(_onboardingKey, true);

  static Future<void> setLanguageCode(String code) =>
      _prefs.setString(_languageKey, code);
}
