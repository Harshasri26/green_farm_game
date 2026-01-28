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
    final prefs = await SharedPreferences.getInstance();
    for (final e in profile.entries) {
      await prefs.setString(e.key, e.value);
    }
  }

  static Future<Map<String, String>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '',
      'crop': prefs.getString('crop') ?? '',
      'location': prefs.getString('location') ?? '',
      'farmSize': prefs.getString('farmSize') ?? '',
    };
  }

  static Future<bool> isProfileComplete() async {
    final p = await getProfile();
    return (p['name'] ?? '').trim().isNotEmpty &&
        (p['location'] ?? '').trim().isNotEmpty &&
        (p['crop'] ?? '').trim().isNotEmpty;
  }
}
