import 'package:flutter/material.dart';

/// Port of components/HealCrop.js
class HealCrop extends StatelessWidget {
  const HealCrop({super.key});

  @override
  Widget build(BuildContext context) {
    Widget step(String icon, String line1, String line2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 5),
          Text('$line1\n$line2', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFCCCCCC)),
      ),
      child: Column(
        children: [
          const Text('Heal your Crop', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              step('🌱', 'Take a', 'Picture'),
              const Text('➜', style: TextStyle(fontSize: 18, color: Color(0xFF777777))),
              step('📱', 'See', 'diagnosis'),
              const Text('➜', style: TextStyle(fontSize: 18, color: Color(0xFF777777))),
              step('🧴', 'Get', 'Medicine'),
            ],
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B3D02),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Take a picture',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
