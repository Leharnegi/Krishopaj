import 'package:flutter/material.dart';
import '../models/farm.dart';

/// Port of screens/FarmInfoScreen.js
class FarmInfoScreen extends StatefulWidget {
  const FarmInfoScreen({super.key});

  @override
  State<FarmInfoScreen> createState() => _FarmInfoScreenState();
}

class _FarmInfoScreenState extends State<FarmInfoScreen> {
  final Set<String> _completedTasks = {};

  String _calculateHarvestDate(String? crop) {
    final harvestDays = {
      'Wheat': 120,
      'Rice': 130,
      'Corn': 90,
      'Cotton': 160,
      'Sugarcane': 365,
    };
    final days = harvestDays[crop] ?? 100;
    final date = DateTime.now().add(Duration(days: days));
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPriorityColor(String priority) {
    switch (priority) {
      case 'high': return '#ef5350';
      case 'medium': return '#ff9800';
      case 'low': return '#4caf50';
      default: return '#757575';
    }
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final Farm? farm = args['farm'] as Farm?;

    final irrigation = [
      {'day': 'Today', 'time': '6:00 AM', 'action': 'Light watering - Check soil moisture', 'priority': 'high'},
      {'day': 'Tomorrow', 'time': '6:00 AM', 'action': 'Deep watering - 2 inches', 'priority': 'medium'},
      {'day': 'Day 3', 'time': '6:00 AM', 'action': 'Skip watering - Check weather', 'priority': 'low'},
      {'day': 'Day 4', 'time': '6:00 AM', 'action': 'Moderate watering - 1.5 inches', 'priority': 'medium'},
    ];

    final fertilization = [
      {'stage': 'Current Stage', 'action': 'Apply NPK fertilizer (20-20-20)', 'timing': 'This week', 'amount': '50kg/acre'},
      {'stage': 'Growing Stage', 'action': 'Apply urea for nitrogen boost', 'timing': '2 weeks from now', 'amount': '25kg/acre'},
      {'stage': 'Pre-flowering', 'action': 'Apply potash for flower development', 'timing': '4 weeks from now', 'amount': '30kg/acre'},
      {'stage': 'Harvest prep', 'action': 'Stop fertilization 2 weeks before harvest', 'timing': 'Before harvest', 'amount': 'N/A'},
    ];

    final pestControl = [
      {'pest': 'General prevention', 'action': 'Apply neem oil spray', 'frequency': 'Weekly', 'status': 'scheduled'},
      {'pest': 'Common insects', 'action': 'Monitor for aphids and mites', 'frequency': 'Daily check', 'status': 'monitoring'},
      {'pest': 'Fungal diseases', 'action': 'Apply fungicide if humidity > 80%', 'frequency': 'As needed', 'status': 'monitoring'},
    ];

    final harvesting = [
      {'milestone': 'Estimated harvest date', 'date': _calculateHarvestDate(farm?.crop)},
      {'milestone': 'Pre-harvest preparations', 'date': '1 week before harvest'},
      {'milestone': 'Optimal moisture for harvest', 'date': 'Harvest day'},
    ];

    Widget sectionCard(String title, List<Widget> children) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF122B24),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF1F3D36)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      );
    }

    Widget completeButton(String taskKey) {
      final done = _completedTasks.contains(taskKey);
      return GestureDetector(
        onTap: () => setState(() {
          if (done) {
            _completedTasks.remove(taskKey);
          } else {
            _completedTasks.add(taskKey);
          }
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(6)),
          child: Text(
            done ? '✓ Completed' : 'Mark Complete',
            style: TextStyle(color: done ? const Color(0xFFA5D6A7) : const Color(0xFF0B1F1A), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

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
                  Text(farm?.name ?? 'Farm Details', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // FARM OVERVIEW
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF122B24),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF1F3D36)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Farm Overview', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _overviewItem('🌾 Crop', farm?.crop ?? 'N/A'),
                              _overviewItem('📏 Area', farm?.area ?? 'N/A'),
                              _overviewItem('📍 Location', farm?.location ?? 'N/A'),
                              if (farm?.predictedYield != null) _overviewItem('📊 Expected Yield', '${farm!.predictedYield} tons'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // IRRIGATION SCHEDULE
                    sectionCard('💧 Irrigation Schedule', [
                      ...List.generate(irrigation.length, (index) {
                        final item = irrigation[index];
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: const Color(0xFF0B1F1A), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['day']!, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 16, fontWeight: FontWeight.bold)),
                                  Container(width: 8, height: 8, decoration: BoxDecoration(color: _hexToColor(_getPriorityColor(item['priority']!)), shape: BoxShape.circle)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(item['time']!, style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 14)),
                              const SizedBox(height: 5),
                              Text(item['action']!, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 14)),
                              const SizedBox(height: 10),
                              completeButton('irrigation-$index'),
                            ],
                          ),
                        );
                      }),
                    ]),

                    // FERTILIZATION PLAN
                    sectionCard('🧪 Fertilization Plan', [
                      ...List.generate(fertilization.length, (index) {
                        final item = fertilization[index];
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: const Color(0xFF0B1F1A), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['stage']!, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(item['timing']!, style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(item['action']!, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 14)),
                              const SizedBox(height: 5),
                              Text('Amount: ${item['amount']}', style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
                              const SizedBox(height: 10),
                              completeButton('fertilizer-$index'),
                            ],
                          ),
                        );
                      }),
                    ]),

                    // PEST CONTROL
                    sectionCard('🐛 Pest Control', [
                      ...List.generate(pestControl.length, (index) {
                        final item = pestControl[index];
                        final isScheduled = item['status'] == 'scheduled';
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: const Color(0xFF0B1F1A), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['pest']!, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(item['action']!, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 14)),
                              const SizedBox(height: 5),
                              Text('Frequency: ${item['frequency']}', style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isScheduled ? const Color(0xFF2ECC71) : const Color(0xFFFF9800),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(item['status']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ]),

                    // HARVESTING TIMELINE
                    sectionCard('🌾 Harvesting Timeline', [
                      ...List.generate(harvesting.length, (index) {
                        final item = harvesting[index];
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: const Color(0xFF0B1F1A), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(item['milestone']!, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 14))),
                              Text(item['date']!, style: const TextStyle(color: Color(0xFF2ECC71), fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ]),

                    // WEATHER IMPACT
                    sectionCard('🌤️ Weather Impact', [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _weatherItem('Temperature', '28°C - Optimal'),
                          _weatherItem('Humidity', '65% - Good'),
                          _weatherItem('Rainfall', 'Expected in 3 days'),
                          _weatherItem('Soil Moisture', '45% - Adequate'),
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewItem(String label, String value) {
    return Container(
      width: (MediaQuery.of(context).size.width - 80) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF0B1F1A), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _weatherItem(String label, String value) {
    return Container(
      width: (MediaQuery.of(context).size.width - 90) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF0B1F1A), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
