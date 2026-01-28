import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'localization/app_localizations.dart';
import 'utils/language_pref.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/language_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<String?> _localeFuture = LanguagePref.getLanguage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _localeFuture,
      builder: (context, snapshot) {
        final code = snapshot.data;
        final locale = code != null && code.isNotEmpty
            ? Locale(code)
            : const Locale('en');
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Green Farm Game',
          theme: ThemeData(
            primarySwatch: Colors.green,
            useMaterial3: true,
          ),
          locale: locale,
          localizationsDelegates: const [AppLocalizationsDelegate()],
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('te'),
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/otp': (context) => const OtpScreen(),
            '/language': (context) => const LanguageScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/home': (context) => const HomeScreen(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
