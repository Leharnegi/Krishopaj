import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/fake_api.dart';
import '../services/storage_service.dart';
import '../models/farm.dart';

/// Port of screens/RecommendationScreen.js
class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  LiveData? _data;
  bool _loading = true;
  String? _result;
  bool _predictLoading = false;
  String? _error;
  Timer? _interval;

  bool _showYieldForm = false;
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _cropController = TextEditingController();
  final _yearController = TextEditingController(text: DateTime.now().year.toString());
  final _seasonController = TextEditingController(text: 'Rabi');
  final _areaController = TextEditingController();
  Map<String, dynamic>? _yieldPrediction;
  bool _yieldLoading = false;
  bool _locationLoading = false;

  @override
  void initState() {
    super.initState();
    _interval = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _data = generateLiveData();
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _interval?.cancel();
    _stateController.dispose();
    _districtController.dispose();
    _cropController.dispose();
    _yearController.dispose();
    _seasonController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _handlePredict() async {
    if (_data == null) return;
    setState(() {
      _predictLoading = true;
      _error = null;
    });
    try {
      final crop = getRecommendation(_data!);
      final finalResult = await fakeApiCall(crop);
      setState(() {
        _result = finalResult;
        _cropController.text = finalResult;
      });
    } catch (e) {
      setState(() => _error = 'API failed. Please try again.');
    } finally {
      setState(() => _predictLoading = false);
    }
  }

  Future<void> _handleYieldPrediction() async {
    if (_stateController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _cropController.text.isEmpty ||
        _areaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    setState(() => _yieldLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      final yieldPerAcre = (Random().nextDouble() * 2 + 0.5).toStringAsFixed(2);
      final totalYield = (double.parse(yieldPerAcre) * double.parse(_areaController.text)).toStringAsFixed(2);
      setState(() {
        _yieldPrediction = {
          'predicted_yield': yieldPerAcre,
          'totalYield': totalYield,
          'yieldPerAcre': yieldPerAcre,
        };
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to predict yield. Please try again.')));
    } finally {
      setState(() => _yieldLoading = false);
    }
  }

  Future<void> _fetchLocation() async {
    setState(() => _locationLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _stateController.text = 'Delhi';
      _districtController.text = 'Delhi NCR';
      _locationLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('State: Delhi, District: Delhi NCR')));
    }
  }

  Future<void> _handleAddToFarm() async {
    final newFarm = Farm(
      id: DateTime.now().millisecondsSinceEpoch,
      name: '${_cropController.text} Farm',
      crop: _cropController.text,
      area: '${_areaController.text} Acre',
      location: '${_stateController.text}, ${_districtController.text}',
      predictedYield: _yieldPrediction?['totalYield'],
      yieldPerAcre: _yieldPrediction?['yieldPerAcre'],
    );

    await StorageService.addFarm(newFarm);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Farm Added Successfully!'),
          content: Text('${newFarm.name} has been added to your farms.\n\nLocation: ${newFarm.location}\nArea: ${newFarm.area}\nPredicted Yield: ${newFarm.predictedYield} tons'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacementNamed('Dashboard', arguments: {'name': 'User', 'refreshFarms': true});
              },
              child: const Text('View My Farms'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Add Another'),
            ),
          ],
        ),
      );
    }
  }

  Widget _dataItem(String label, String value, String unit) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1F1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 24, fontWeight: FontWeight.bold)),
            Text(unit, style: const TextStyle(color: Color(0xFF5A8A7A), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {String? hint, TextInputType? keyboardType}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF5A8A7A)),
                filled: true,
                fillColor: const Color(0xFF0B1F1A),
                contentPadding: const EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2ECC71)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2ECC71)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Live Soil Data 📡', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE8F5E9))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF122B24),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Color(0xFF2ECC71), size: 8),
                        SizedBox(width: 6),
                        Text('LIVE', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              if (_loading || _data == null)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Color(0xFF2ECC71)),
                      SizedBox(height: 15),
                      Text('Fetching sensor data...', style: TextStyle(color: Color(0xFFA5D6A7))),
                    ],
                  ),
                )
              else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF122B24),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1F3D36)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _dataItem('Nitrogen', '${_data!.nitrogen}', 'mg/kg'),
                          _dataItem('Phosphorus', '${_data!.phosphorus}', 'mg/kg'),
                          _dataItem('Potassium', '${_data!.potassium}', 'mg/kg'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _dataItem('Temperature', '${_data!.temperature}', '°C'),
                          _dataItem('Humidity', '${_data!.humidity}', '%'),
                          _dataItem('pH Level', _data!.ph, 'pH'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _dataItem('Rainfall', '${_data!.rainfall}', 'mm'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 10),

              GestureDetector(
                onTap: _predictLoading ? null : _handlePredict,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Color(0x4D2ECC71), offset: Offset(0, 6), blurRadius: 8),
                    ],
                  ),
                  child: _predictLoading
                      ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF0B1F1A), strokeWidth: 2)))
                      : const Text('Get Recommendation', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF0B1F1A), fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C1F1A),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE74C3C)),
                  ),
                  child: Row(
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_error!, style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 14))),
                    ],
                  ),
                ),

              if (_result != null)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF122B24),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2ECC71), width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🌾', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          const Text('Recommended Crop', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(_result!, style: const TextStyle(color: Color(0xFF2ECC71), fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF1F3D36)))),
                        child: const Text('Based on current soil conditions', style: TextStyle(color: Color(0xFF7FAF9F), fontSize: 12, fontStyle: FontStyle.italic)),
                      ),
                    ],
                  ),
                ),

              // Yield Prediction Section
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => setState(() => _showYieldForm = !_showYieldForm),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF122B24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1F3D36)),
                  ),
                  child: Text(
                    '${_showYieldForm ? '▼' : '▶'} Predict Yield 📊',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              if (_showYieldForm)
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF122B24),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF1F3D36)),
                  ),
                  child: Column(
                    children: [
                      const Text('Enter Farm Details', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _locationLoading ? null : _fetchLocation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F3D36),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: const Color(0xFF2ECC71)),
                          ),
                          child: _locationLoading
                              ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Color(0xFF0B1F1A), strokeWidth: 2)))
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('📍', style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 8),
                                    Text('Auto-fill Location', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 14, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _inputField('State *', _stateController, hint: 'e.g., Delhi'),
                          _inputField('District *', _districtController, hint: 'e.g., Delhi NCR'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _inputField('Crop *', _cropController, hint: 'e.g., rice'),
                          _inputField('Area (acres) *', _areaController, hint: 'e.g., 100', keyboardType: TextInputType.number),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _inputField('Year', _yearController, hint: '2026', keyboardType: TextInputType.number),
                          _inputField('Season', _seasonController, hint: 'e.g., Rabi'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _yieldLoading ? null : _handleYieldPrediction,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ECC71),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(color: Color(0x4D2ECC71), offset: Offset(0, 4), blurRadius: 6),
                            ],
                          ),
                          child: _yieldLoading
                              ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF0B1F1A), strokeWidth: 2)))
                              : const Text('Predict Yield', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF0B1F1A), fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

              if (_yieldPrediction != null)
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF122B24),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF2ECC71), width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('📊', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          const Text('Yield Prediction', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Yield per Acre', style: TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
                                const SizedBox(height: 5),
                                Text('${_yieldPrediction!['yieldPerAcre']} tons', style: const TextStyle(color: Color(0xFF2ECC71), fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 40, color: const Color(0xFF1F3D36), margin: const EdgeInsets.symmetric(horizontal: 20)),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Total Yield', style: TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
                                const SizedBox(height: 5),
                                Text('${_yieldPrediction!['totalYield']} tons', style: const TextStyle(color: Color(0xFF2ECC71), fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${_yieldPrediction!['yieldPerAcre']} × ${_areaController.text} acres = ${_yieldPrediction!['totalYield']} tons',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _handleAddToFarm,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF2C2C),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: const [
                              BoxShadow(color: Color(0x4D2ECC71), offset: Offset(0, 4), blurRadius: 6),
                            ],
                          ),
                          child: const Text('Add to My Farms', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
