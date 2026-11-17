import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../services/storage_service.dart';

/// Port of screens/SensorDataScreen.js
class SensorDataScreen extends StatefulWidget {
  const SensorDataScreen({super.key});

  @override
  State<SensorDataScreen> createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  final _random = Random();
  List<Farm> _farms = [];
  Farm? _selectedFarm;
  Map<int, Map<String, dynamic>> _farmSensorData = {};
  Timer? _interval;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  @override
  void dispose() {
    _interval?.cancel();
    super.dispose();
  }

  Future<void> _loadFarms() async {
    final farms = await StorageService.getUserFarms();
    setState(() {
      _farms = farms;
      if (farms.isNotEmpty && _selectedFarm == null) {
        _selectedFarm = farms[0];
      }
    });
    if (farms.isNotEmpty) {
      _initializeFarmSensorData();
      _interval?.cancel();
      _interval = Timer.periodic(const Duration(seconds: 30), (_) => _updateFarmSensorData());
    }
  }

  void _initializeFarmSensorData() {
    final initialData = <int, Map<String, dynamic>>{};
    for (final farm in _farms) {
      initialData[farm.id] = {
        'nitrogen': 45 + _random.nextDouble() * 30,
        'phosphorus': 25 + _random.nextDouble() * 25,
        'potassium': 180 + _random.nextDouble() * 70,
        'moisture': 35 + _random.nextDouble() * 25,
        'ph': 6.2 + _random.nextDouble() * 1.6,
        'temperature': 22 + _random.nextDouble() * 8,
        'humidity': 55 + _random.nextDouble() * 25,
        'isConnected': _random.nextDouble() > 0.2,
        'lastUpdate': DateTime.now(),
      };
    }
    setState(() => _farmSensorData = initialData);
  }

  void _updateFarmSensorData() {
    setState(() {
      for (final farm in _farms) {
        final d = _farmSensorData[farm.id];
        if (d != null) {
          _farmSensorData[farm.id] = {
            ...d,
            'nitrogen': _clamp((d['nitrogen'] as double) + (_random.nextDouble() - 0.5) * 5, 20, 80),
            'phosphorus': _clamp((d['phosphorus'] as double) + (_random.nextDouble() - 0.5) * 3, 15, 55),
            'potassium': _clamp((d['potassium'] as double) + (_random.nextDouble() - 0.5) * 10, 150, 280),
            'moisture': _clamp((d['moisture'] as double) + (_random.nextDouble() - 0.5) * 4, 25, 70),
            'ph': _clamp((d['ph'] as double) + (_random.nextDouble() - 0.5) * 0.2, 5.5, 8.5),
            'temperature': _clamp((d['temperature'] as double) + (_random.nextDouble() - 0.5) * 2, 18, 35),
            'humidity': _clamp((d['humidity'] as double) + (_random.nextDouble() - 0.5) * 5, 40, 90),
            'lastUpdate': DateTime.now(),
            'isConnected': _random.nextDouble() > 0.1,
          };
        }
      }
    });
  }

  double _clamp(double value, double min, double max) => value.clamp(min, max);

  Map<String, dynamic> _getCurrentSensorData() {
    if (_selectedFarm == null) {
      return {'nitrogen': 0.0, 'phosphorus': 0.0, 'potassium': 0.0, 'moisture': 0.0, 'ph': 0.0, 'temperature': 0.0, 'humidity': 0.0};
    }
    return _farmSensorData[_selectedFarm!.id] ?? {'nitrogen': 0.0, 'phosphorus': 0.0, 'potassium': 0.0, 'moisture': 0.0, 'ph': 0.0, 'temperature': 0.0, 'humidity': 0.0};
  }

  bool _getCurrentFarmConnectionStatus() {
    if (_selectedFarm == null) return false;
    return _farmSensorData[_selectedFarm!.id]?['isConnected'] ?? false;
  }


  Map<String, String> _getNitrogenStatus() {
    final v = (_getCurrentSensorData()['nitrogen'] as double);
    if (v < 30) return {'status': 'problem', 'advice': 'Add urea fertilizer'};
    if (v < 50) return {'status': 'warning', 'advice': 'Add some urea'};
    return {'status': 'good', 'advice': 'Fertilizer is good'};
  }

  Map<String, String> _getPhosphorusStatus() {
    final v = (_getCurrentSensorData()['phosphorus'] as double);
    if (v < 20) return {'status': 'problem', 'advice': 'Add DAP fertilizer'};
    if (v < 35) return {'status': 'warning', 'advice': 'Add some DAP'};
    return {'status': 'good', 'advice': 'Fertilizer is good'};
  }

  Map<String, String> _getPotassiumStatus() {
    final v = (_getCurrentSensorData()['potassium'] as double);
    if (v < 150) return {'status': 'problem', 'advice': 'Add potash fertilizer'};
    if (v < 200) return {'status': 'warning', 'advice': 'Add some potash'};
    return {'status': 'good', 'advice': 'Fertilizer is good'};
  }

  Map<String, String> _getMoistureStatus() {
    final v = (_getCurrentSensorData()['moisture'] as double);
    if (v < 30) return {'status': 'problem', 'advice': 'Water needed'};
    if (v < 50) return {'status': 'warning', 'advice': 'Add some water'};
    return {'status': 'good', 'advice': 'Water is good'};
  }

  Map<String, String> _getPhStatus() {
    final v = (_getCurrentSensorData()['ph'] as double);
    if (v < 6.0) return {'status': 'problem', 'advice': 'Add lime to soil'};
    if (v > 7.5) return {'status': 'warning', 'advice': 'Add cow dung'};
    return {'status': 'good', 'advice': 'Soil is good'};
  }

  Map<String, String> _getTemperatureStatus() {
    final v = (_getCurrentSensorData()['temperature'] as double);
    if (v < 20) return {'status': 'warning', 'advice': 'Cold weather'};
    if (v > 32) return {'status': 'warning', 'advice': 'Hot weather'};
    return {'status': 'good', 'advice': 'Temperature is good'};
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'good': return const Color(0xFF4CAF50);
      case 'warning': return const Color(0xFFFF9800);
      default: return const Color(0xFFEF5350);
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'good': return '✓ Good';
      case 'warning': return '⚠ Warning';
      default: return '✗ Problem';
    }
  }

  Widget _simpleSensorCard(String title, String value, String unit, String icon, Map<String, String> status) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF122B24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F3D36), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text('$value $unit', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: _statusColor(status['status']!), borderRadius: BorderRadius.circular(15)),
            child: Text(_statusLabel(status['status']!), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Text(status['advice']!, style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensorData = _getCurrentSensorData();
    final currentFarmConnected = _getCurrentFarmConnectionStatus();

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
                  const Text('Farm Sensors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(color: currentFarmConnected ? const Color(0xFF4CAF50) : const Color(0xFFEF5350), shape: BoxShape.circle),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // FARM SELECTION
                    if (_farms.isNotEmpty)
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
                            const Text('Select Farm:', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _farms.length,
                                itemBuilder: (context, index) {
                                  final farm = _farms[index];
                                  final selected = _selectedFarm?.id == farm.id;
                                  final connected = _farmSensorData[farm.id]?['isConnected'] ?? false;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedFarm = farm),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: selected ? const Color(0xFF2E7D32) : const Color(0xFF1F3D36),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: selected ? const Color(0xFF4CAF50) : Colors.transparent, width: 2),
                                      ),
                                      child: Row(
                                        children: [
                                          Text('🌾 ${farm.name}', style: TextStyle(color: selected ? Colors.white : const Color(0xFFA5D6A7), fontSize: 14, fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 8),
                                          Container(width: 8, height: 8, decoration: BoxDecoration(color: connected ? const Color(0xFF4CAF50) : const Color(0xFFEF5350), shape: BoxShape.circle)),
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

                    // CURRENT FARM STATUS
                    if (_selectedFarm != null)
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
                          children: [
                            Text('${_selectedFarm!.name} - Sensor Status', style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(currentFarmConnected ? '✓ Connected' : '✗ Not Connected', style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 16)),
                            const SizedBox(height: 5),
                            Text(
                              'Update: ${_farmSensorData[_selectedFarm!.id]?['lastUpdate'] != null ? (_farmSensorData[_selectedFarm!.id]!['lastUpdate'] as DateTime).toLocal().toString().substring(11, 19) : 'Never'}',
                              style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text('📍 ${_selectedFarm!.location} • 🌾 ${_selectedFarm!.crop} • 📏 ${_selectedFarm!.area}', style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),

                    // NO FARMS MESSAGE
                    if (_farms.isEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: const Color(0xFF122B24),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF1F3D36)),
                        ),
                        child: Column(
                          children: [
                            const Text('No Farms Found', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            const Text('Please add a farm from the dashboard to view sensor data.', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 16, height: 1.4), textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed('Recommendation'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(8)),
                                child: const Text('Add Farm', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // MAIN SENSORS GRID
                    const Text('🌾 Fertilizer and Soil Information', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 0,
                      children: [
                        _simpleSensorCard('Nitrogen', (sensorData['nitrogen'] as double).toStringAsFixed(0), 'mg/kg', '🧪', _getNitrogenStatus()),
                        _simpleSensorCard('Phosphorus', (sensorData['phosphorus'] as double).toStringAsFixed(0), 'mg/kg', '⚗️', _getPhosphorusStatus()),
                        _simpleSensorCard('Potassium', (sensorData['potassium'] as double).toStringAsFixed(0), 'mg/kg', '🧫', _getPotassiumStatus()),
                        _simpleSensorCard('Moisture', (sensorData['moisture'] as double).toStringAsFixed(0), '%', '💧', _getMoistureStatus()),
                        _simpleSensorCard('pH Level', (sensorData['ph'] as double).toStringAsFixed(1), 'pH', '🌡️', _getPhStatus()),
                        _simpleSensorCard('Temperature', (sensorData['temperature'] as double).toStringAsFixed(0), '°C', '🌡️', _getTemperatureStatus()),
                      ],
                    ),

                    // QUICK ADVICE
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 5, bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A4D3A),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF2ECC71), width: 2),
                      ),
                      child: Column(
                        children: [
                          const Text("📝 Today's Advice", style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(
                            '${(sensorData['moisture'] as double) < 40 ? "• Water your field today\n" : "• Water level is good\n"}'
                            '${(sensorData['nitrogen'] as double) < 40 ? "• Add urea fertilizer\n" : "• Nitrogen level is good\n"}'
                            '${(sensorData['ph'] as double) < 6.5 ? "• Add lime to soil" : "• Soil condition is good"}',
                            style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 14, height: 1.4),
                          ),
                        ],
                      ),
                    ),

                    // SIMPLE TUTORIALS
                    const Text('🔧 Learn Sensor Setup', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF122B24),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF1F3D36), width: 2),
                      ),
                      child: const Column(
                        children: [
                          Text('📱 How to Install Sensors', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Easy Video Tutorials', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 14)),
                          SizedBox(height: 8),
                          Text('Tap to Watch', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
