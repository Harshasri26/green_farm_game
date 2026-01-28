import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthWeb {
  static Future<ConfirmationResult> sendOtp(String phone) async {
    final auth = FirebaseAuth.instance;
    // No verifier: SDK uses an invisible reCAPTCHA automatically.
    return await auth.signInWithPhoneNumber(phone);
  }
}
