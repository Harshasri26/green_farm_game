import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthWeb {
  static Future<ConfirmationResult> sendOtp(String phone) async {
    final auth = FirebaseAuth.instance;

    return await auth.signInWithPhoneNumber(
      phone,
      RecaptchaVerifier(
        container: 'recaptcha-container',
        size: RecaptchaVerifierSize.normal,
        theme: RecaptchaVerifierTheme.light,
      ),
    );
  }
}
