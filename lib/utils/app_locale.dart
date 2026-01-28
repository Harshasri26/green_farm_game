import 'package:flutter/material.dart';
import 'language_pref.dart';

/// App-wide locale. Update when user picks language so UI switches immediately.
class AppLocale {
  static final ValueNotifier<Locale> current = ValueNotifier(const Locale('en'));

  static Future<void> load() async {
    final code = await LanguagePref.getLanguage();
    if (code != null && code.isNotEmpty) {
      current.value = Locale(code);
    }
  }

  static void set(Locale locale) {
    current.value = locale;
  }
}
