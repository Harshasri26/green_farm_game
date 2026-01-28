import 'phone_auth_web.dart';

Future<Object?> sendOtp(String phone) async {
  return await PhoneAuthWeb.sendOtp(phone);
}
