/// Stub for mobile: demo mode — accept any 6-digit OTP when no [ConfirmationResult].
Future<bool> verifyOtp(Object? arg, String otp) async {
  if (arg != null) return false;
  return otp.length == 6;
}
