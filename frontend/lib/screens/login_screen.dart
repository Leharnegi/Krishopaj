import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Port of screens/LoginScreen.js
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _handleSendOTP() {
    Navigator.of(context).pushNamed('OTP', arguments: {'phone': _phoneController.text, 'type': 'login'});
  }

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
              const Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE8F5E9))),
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
                onTap: _handleSendOTP,
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
                onTap: () => Navigator.of(context).pushNamed('Signup'),
                child: const Text('New user? Signup', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 14)),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('Forgot'),
                child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
