import 'package:flutter/material.dart';

/// Port of screens/YieldScreen.js
class YieldScreen extends StatelessWidget {
  const YieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final dynamic tips = args['tips'];
    final title = args['title'] ?? 'Tips';
    final List<String> tipsArray = tips is List ? tips.map((e) => e.toString()).toList() : [tips?.toString() ?? ''];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F1A),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text('← Back', style: TextStyle(fontSize: 16, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  ),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: List.generate(tipsArray.length, (index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${index + 1}.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(tipsArray[index], style: const TextStyle(fontSize: 14, height: 1.4, color: Color(0xFF333333))),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
