import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Port of screens/SignupScreen.js
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Ritika Rawat');
  final TextEditingController _phoneController = TextEditingController(text: '7248324329');

  void _handleSignup() {
    Navigator.of(context).pushNamed('OTP', arguments: {
      'phone': _phoneController.text,
      'type': 'signup',
      'name': _nameController.text,
    });
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
              const Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE8F5E9))),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Enter Name'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Enter Phone Number'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _handleSignup,
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
                child: const Text('Already have an account? Login', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }
}
