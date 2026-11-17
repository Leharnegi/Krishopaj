import 'package:flutter/material.dart';
import 'simple_dropdown.dart';

/// Port of components/Header.js
class AppHeader extends StatelessWidget {
  final String name;

  const AppHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back,', style: TextStyle(color: Color(0xFF666666))),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const SimpleDropdown(),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => Navigator.of(context).pushReplacementNamed('About'),
                child: Container(
                  color: const Color(0xFFEEEEEE),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
