import 'package:flutter/material.dart';
import '../utils/language_pref.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Language",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            languageTile(context, "English", 'en'),
            languageTile(context, "हिन्दी", 'hi'),
            languageTile(context, "తెలుగు", 'te'),
          ],
        ),
      ),
    );
  }

  Widget languageTile(BuildContext context, String lang, String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 200, // fixed width for better alignment
        height: 50, // button height
        child: ElevatedButton(
          onPressed: () {
            // Save chosen language in app (can use shared_preferences)
            // Then navigate to profile or home
            Navigator.pushReplacementNamed(context, '/profile', arguments: code);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            lang,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
