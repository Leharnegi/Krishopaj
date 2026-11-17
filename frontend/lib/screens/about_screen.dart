import 'package:flutter/material.dart';

/// Port of screens/AboutScreen.js
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget card(List<String> lines) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF122B24),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines
              .map((l) => Text(l, style: const TextStyle(fontSize: 14, color: Color(0xFFE8F5E9), height: 1.6)))
              .toList(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F1A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('       About Krishopaj 🌱',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE8F5E9))),
            const SizedBox(height: 20),
            card([
              'Krishopaj is a smart farming application designed to help farmers',
              'with modern agricultural solutions.',
            ]),
            const Text('Features:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFA5D6A7))),
            card([
              '• 🌾 Crop yield prediction',
              '• 📊 Yield improvement recommendations',
              '• 💧 Smart irrigation tips and ⏱️ Right time to irrigate land',
              '• 🌱 Fertilizer guidance and ⏰ Best time to fertilize crops',
              '• ☁️ Live weather reports',
              '• 🐛 Pest alerts and crop protection',
              '• 💰 Real-time mandi prices',
              '• 💬 Chatbot for instant help',
            ]),
            const Text('Our Mission:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFA5D6A7))),
            card([
              'To empower farmers with technology and make agriculture more efficient',
              'and profitable.',
            ]),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('Login'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(25)),
                child: const Text('Login', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF081C15), fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('Signup'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2ECC71)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text('Sign Up', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
