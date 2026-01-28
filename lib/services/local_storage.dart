import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  static Future<String?> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language');
  }

  static Future<void> saveProfile(Map<String, String> profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profile.forEach((key, value) async {
      await prefs.setString(key, value);
    });
  }

  static Future<Map<String, String>> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '',
      'crop': prefs.getString('crop') ?? '',
      'location': prefs.getString('location') ?? '',
      'farmSize': prefs.getString('farmSize') ?? '',
    };
  }
}
