import 'package:shared_preferences/shared_preferences.dart';

class LanguagePref {
  static const String keyLanguage = 'languageCode';

  static Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLanguage, code);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLanguage);
  }
}
