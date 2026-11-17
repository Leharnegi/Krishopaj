import 'package:flutter/material.dart';

/// Port of screens/SetPasswordScreen.js
class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  final TextEditingController _confirmController = TextEditingController(text: 'password123');

  void _handleSave(Map<String, dynamic> args) {
    if (_passwordController.text == _confirmController.text) {
      Navigator.of(context).pushReplacementNamed('Dashboard', arguments: {'name': args['name'] ?? 'User'});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F1A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Set Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE8F5E9))),
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Enter Password'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration('Confirm Password'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _handleSave(args),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text('Save Password', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF081C15), fontWeight: FontWeight.bold, fontSize: 16)),
                ),
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
