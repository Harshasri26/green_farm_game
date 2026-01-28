/// Mobile: demo mode — no Firebase phone auth, return null for OTP screen.
Future<Object?> sendOtp(String phone) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return null;
}
