import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../services/alert_service.dart';
import '../services/storage_service.dart';
import '../models/farm.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/heal_crop.dart';

/// Port of screens/DashboardScreen.js
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _name = 'User';
  List<Farm> _farms = [];

  static const List<Map<String, String>> _features = [
    {'title': 'Yield Optimization', 'icon': '🌾'},
    {'title': 'Irrigation Tips', 'icon': '💧'},
    {'title': 'Fertilizer Tips', 'icon': '🧪'},
    {'title': 'Pest Alerts', 'icon': '🐛'},
  ];

  @override
  void initState() {
    super.initState();
    _loadArgs();
    _loadFarms();
    AlertService.instance.initialize();
  }

  void _loadArgs() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['name'] != null) {
      _name = args['name'];
    }
  }

  Future<void> _loadFarms() async {
    final farms = await StorageService.getUserFarms();
    if (mounted) setState(() => _farms = farms);
  }

  Future<void> _handlePress(String type) async {
    List<String> result;
    try {
      result = await getTips(type);
    } catch (e) {
      result = ['Failed to load tips. Please try again.'];
    }
    if (mounted) {
      Navigator.of(context).pushNamed('Yield', arguments: {'tips': result, 'title': type});
    }
  }

  Future<void> _handleDeleteFarm(int farmId) async {
    setState(() => _farms = _farms.where((f) => f.id != farmId).toList());
    await StorageService.deleteFarm(farmId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(name: _name),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // WEATHER + ALERT
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xFF90CAF9),
                              padding: const EdgeInsets.all(15),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('35°C', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('Partly Cloudy'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              color: const Color(0xFFEF5350),
                              padding: const EdgeInsets.all(15),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('⚠ Alerts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text('Soil moisture low', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // FARMS
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('My Farms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed('Recommendation'),
                                child: Container(
                                  color: const Color(0xFF2E7D32),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                  child: const Text('+ Add', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _farms.length,
                              itemBuilder: (context, index) {
                                final farm = _farms[index];
                                return GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed('FarmInfo', arguments: {'farm': farm}),
                                  child: Container(
                                    width: 200,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFC8E6C9)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(farm.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E7D32))),
                                            GestureDetector(
                                              onTap: () => _handleDeleteFarm(farm.id),
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: const BoxDecoration(color: Color(0xFFEF5350), shape: BoxShape.circle),
                                                child: const Center(child: Text('×', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text('🌾 Crop: ${farm.crop}'),
                                        Text('📏 Area: ${farm.area}'),
                                        Text('📍 Location: ${farm.location}'),
                                        if (farm.predictedYield != null)
                                          Text('📊 Yield: ${farm.predictedYield} tons', style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // HEAL CROP
                    const HealCrop(),

                    // TIPS GRID
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 12,
                        children: _features.map((item) {
                          return GestureDetector(
                            onTap: () => _handlePress(item['title']!),
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 50) / 2,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8E6C9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(item['icon']!, style: const TextStyle(fontSize: 28)),
                                  const SizedBox(height: 10),
                                  Text(item['title']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppFooter(activeTab: 'Home'),
          ],
        ),
      ),
    );
  }
}
