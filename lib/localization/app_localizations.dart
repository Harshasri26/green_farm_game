import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'enter_phone': 'Enter phone number',
      'verify': 'Verify OTP',
      'profile': 'My Profile',
    },
    'hi': {
      'login': 'लॉगिन',
      'enter_phone': 'फोन नंबर दर्ज करें',
      'verify': 'ओटीपी सत्यापित करें',
      'profile': 'मेरी प्रोफ़ाइल',
    },
    'te': {
      'login': 'లాగిన్',
      'enter_phone': 'ఫోన్ నంబర్ నమోదు చేయండి',
      'verify': 'ఓటీపీ నిర్ధారించండి',
      'profile': 'నా ప్రొఫైల్',
    },
  };

  String get(String key) {
    final map = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return map[key] ?? _localizedValues['en']![key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_) => false;
}
