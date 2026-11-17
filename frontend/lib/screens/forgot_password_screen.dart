import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Port of screens/ForgetPasswordScreen.js
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '7248324329');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F1A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Forgot Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE8F5E9))),
              const SizedBox(height: 10),
              const Text('Enter your phone number to reset password', style: TextStyle(fontSize: 16, color: Color(0xFFA5D6A7))),
              const SizedBox(height: 30),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
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
                onTap: () => Navigator.of(context).pushNamed('OTP', arguments: {'phone': _phoneController.text, 'type': 'reset'}),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text('Send OTP', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF081C15), fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('Login'),
                child: const Text('Back to Login', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
