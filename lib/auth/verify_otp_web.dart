import 'package:firebase_auth/firebase_auth.dart';

Future<bool> verifyOtp(Object? arg, String otp) async {
  if (arg == null || otp.length != 6) return false;
  try {
    await (arg as ConfirmationResult).confirm(otp);
    return true;
  } catch (_) {
    return false;
  }
}
