import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Port of screens/MandiPriceScreen.js
class MandiPriceScreen extends StatefulWidget {
  const MandiPriceScreen({super.key});

  @override
  State<MandiPriceScreen> createState() => _MandiPriceScreenState();
}

class _MandiPriceScreenState extends State<MandiPriceScreen> {
  final _cropController = TextEditingController();
  final _locationController = TextEditingController();
  final _amountController = TextEditingController();
  Map<String, dynamic>? _priceData;
  bool _loading = false;

  Map<String, Map<String, dynamic>> get _basePrices => {
        'wheat': {'min': 2000, 'max': 2500, 'avg': 2250, 'unit': 'quintal'},
        'rice': {'min': 1800, 'max': 2200, 'avg': 2000, 'unit': 'quintal'},
        'corn': {'min': 1500, 'max': 1900, 'avg': 1700, 'unit': 'quintal'},
        'cotton': {'min': 6000, 'max': 7500, 'avg': 6750, 'unit': 'quintal'},
        'sugarcane': {'min': 300, 'max': 400, 'avg': 350, 'unit': 'quintal'},
        'pulses': {'min': 4000, 'max': 5500, 'avg': 4750, 'unit': 'quintal'},
        'soybean': {'min': 3500, 'max': 4500, 'avg': 4000, 'unit': 'quintal'},
        'mustard': {'min': 4500, 'max': 5500, 'avg': 5000, 'unit': 'quintal'},
      };

  Map<String, double> get _locationMultipliers => {
        'haryana': 1.05,
        'punjab': 1.08,
        'up': 1.02,
        'rajasthan': 0.98,
        'maharashtra': 1.03,
        'gujarat': 1.06,
      };

  Map<String, dynamic> _getMandiPrices(String crop, String loc, String qty) {
    final cropKey = crop.toLowerCase();
    final priceInfo = _basePrices[cropKey] ?? {'min': 2000, 'max': 3000, 'avg': 2500, 'unit': 'quintal'};
    final multiplier = _locationMultipliers[loc.toLowerCase()] ?? 1.0;
    final qtyValue = double.tryParse(qty) ?? 0;
    final now = DateTime.now();

    return {
      'crop': crop,
      'location': loc,
      'quantity': qty,
      'minPrice': ((priceInfo['min'] as int) * multiplier).round(),
      'maxPrice': ((priceInfo['max'] as int) * multiplier).round(),
      'avgPrice': ((priceInfo['avg'] as int) * multiplier).round(),
      'unit': priceInfo['unit'],
      'estimatedValue': (((priceInfo['avg'] as int) * multiplier) * qtyValue).round(),
      'marketTrend': Random().nextBool() ? 'up' : 'down',
      'trendPercent': (Random().nextDouble() * 10).toStringAsFixed(1),
      'lastUpdated': '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
    };
  }

  void _handleGetPrice() {
    if (_cropController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter crop name')));
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter location')));
      return;
    }
    if (_amountController.text.trim().isEmpty || double.tryParse(_amountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid amount')));
      return;
    }

    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _priceData = _getMandiPrices(_cropController.text, _locationController.text, _amountController.text);
        _loading = false;
      });
    });
  }

  void _handleReset() {
    setState(() {
      _cropController.clear();
      _locationController.clear();
      _amountController.clear();
      _priceData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('Mandi Price Checker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // INPUT FORM
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
                          const Text('🌾 Get Market Prices', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          _inputGroup('Crop Name', _cropController, 'e.g., Wheat, Rice, Corn'),
                          _inputGroup('Location', _locationController, 'e.g., Haryana, Punjab, UP'),
                          _inputGroup('Amount (in Quintals)', _amountController, 'e.g., 10, 50, 100', keyboardType: TextInputType.number),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: _loading ? null : _handleGetPrice,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(10)),
                                    child: Text(_loading ? 'Loading...' : 'Get Price', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _handleReset,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(color: const Color(0xFFEF5350), borderRadius: BorderRadius.circular(10)),
                                    child: const Text('Reset', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // PRICE RESULTS
                    if (_priceData != null) ...[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF122B24),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                        ),
                        child: Column(
                          children: [
                            const Text('📊 Market Price Analysis', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_priceData!['crop'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text('📍 ${_priceData!['location']}', style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 14)),
                                    const SizedBox(height: 3),
                                    Text('📦 ${_priceData!['quantity']} ${_priceData!['unit']}', style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 14)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Market Trend', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 12)),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: _priceData!['marketTrend'] == 'up' ? const Color(0xFF4CAF50) : const Color(0xFFEF5350),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        '${_priceData!['marketTrend'] == 'up' ? '↑' : '↓'} ${_priceData!['trendPercent']}%',
                                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _priceItem('Min Price', '₹${_priceData!['minPrice']}', 'per ${_priceData!['unit']}'),
                                _priceItem('Avg Price', '₹${_priceData!['avgPrice']}', 'per ${_priceData!['unit']}'),
                                _priceItem('Max Price', '₹${_priceData!['maxPrice']}', 'per ${_priceData!['unit']}'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A4D3A),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: const Color(0xFF2ECC71), width: 2),
                              ),
                              child: Column(
                                children: [
                                  const Text('Estimated Total Value', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text('₹${_priceData!['estimatedValue']}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('Last Updated: ${_priceData!['lastUpdated']}', style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 12)),
                            const SizedBox(height: 5),
                            const Text('* Prices are indicative and may vary based on quality and market conditions', style: TextStyle(color: Color(0xFF7FAF9F), fontSize: 10, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],

                    // HELPFUL TIPS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF122B24),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF1F3D36)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('💡 Selling Tips', style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          Text('• Check multiple mandis for best prices', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 14, height: 1.4)),
                          SizedBox(height: 8),
                          Text('• Consider quality grading for better rates', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 14, height: 1.4)),
                          SizedBox(height: 8),
                          Text('• Monitor market trends before selling', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 14, height: 1.4)),
                          SizedBox(height: 8),
                          Text('• Government MSP may apply for certain crops', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 14, height: 1.4)),
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

  Widget _inputGroup(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : null,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF7FAF9F)),
              filled: true,
              fillColor: const Color(0xFF1F3D36),
              contentPadding: const EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2ECC71)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2ECC71)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceItem(String label, String value, String unit) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xFF1F3D36), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 12)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(unit, style: const TextStyle(color: Color(0xFF7FAF9F), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
