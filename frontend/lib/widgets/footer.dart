import 'package:flutter/material.dart';

/// Port of components/Footer.js
class AppFooter extends StatelessWidget {
  final String activeTab;

  const AppFooter({super.key, required this.activeTab});

  static const List<Map<String, String>> _tabs = [
    {'name': 'Home', 'screen': 'Dashboard', 'icon': '🏠'},
    {'name': 'Yield', 'screen': 'Recommendation', 'icon': '📊'},
    {'name': 'Mandi', 'screen': 'MandiPrice', 'icon': '🛒'},
    {'name': 'Sensors', 'screen': 'SensorData', 'icon': '📡'},
    {'name': 'Chat', 'screen': 'Chatbot', 'icon': '💬'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF122B24),
        border: Border(top: BorderSide(color: Color(0xFF1F3D36))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _tabs.map((tab) {
          final isActive = activeTab == tab['name'];
          return Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(tab['screen']!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tab['icon']!,
                    style: TextStyle(
                      fontSize: isActive ? 24 : 22,
                      color: isActive ? const Color(0xFF2ECC71) : const Color(0xFF7FAF9F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tab['name']!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? const Color(0xFF2ECC71) : const Color(0xFF7FAF9F),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isActive)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 5),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
