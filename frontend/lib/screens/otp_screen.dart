import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Port of screens/OTPScreen.js
class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController(text: '123456');

  void _handleVerify(Map<String, dynamic> args) {
    final type = args['type'];
    final name = args['name'] ?? 'User';
    if (type == 'login') {
      Navigator.of(context).pushReplacementNamed('Dashboard', arguments: {'name': name});
    } else {
      Navigator.of(context).pushNamed('SetPassword', arguments: {'phone': args['phone'], 'name': name});
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final phone = args['phone'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F1A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Verify OTP', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE8F5E9))),
              const SizedBox(height: 10),
              Text('Enter OTP sent to $phone', style: const TextStyle(fontSize: 16, color: Color(0xFFA5D6A7))),
              const SizedBox(height: 30),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Enter 6-digit OTP',
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFE8F5E9),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2ECC71)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2ECC71)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _handleVerify(args),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text('Verify OTP', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF081C15), fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: const Text('Resend OTP', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
