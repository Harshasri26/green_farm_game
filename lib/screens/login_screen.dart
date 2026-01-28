import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

import '../localization/app_localizations.dart';
import '../auth/send_otp_stub.dart'
    if (dart.library.html) '../auth/send_otp_web.dart' as send_otp;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  String _error = '';
  bool _loading = false;

  Future<void> _sendOtp() async {
    final l = AppLocalizations.of(context);
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _error = l.get('enter_phone'));
      return;
    }
    final normalized = phone.startsWith('+') ? phone : '+91$phone';
    setState(() {
      _error = '';
      _loading = true;
    });
    try {
      final result = await send_otp.sendOtp(normalized);
      if (!mounted) return;
      Navigator.pushNamed(context, '/otp', arguments: result);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message ?? l.get('verification_failed'));
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = l.get('verification_failed'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.agriculture,
                  size: 60,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  l.get('welcome_farmer'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.get('login_phone'),
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: l.get('phone_hint'),
                    prefixIcon: const Icon(Icons.phone),
                    errorText: _error.isEmpty ? null : _error,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l.get('send_otp')),
                  ),
                ),
                if (!kIsWeb) ...[
                  const SizedBox(height: 12),
                  Text(
                    l.get('demo_otp'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
