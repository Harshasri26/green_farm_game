import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../utils/app_locale.dart';
import '../utils/language_pref.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l.get('choose_language'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _languageTile(context, l.get('lang_en'), 'en'),
            _languageTile(context, l.get('lang_hi'), 'hi'),
            _languageTile(context, l.get('lang_te'), 'te'),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(BuildContext context, String label, String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            await LanguagePref.setLanguage(code);
            AppLocale.set(Locale(code));
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(context, '/details');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
