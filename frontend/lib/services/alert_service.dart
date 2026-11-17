import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmAlert {
  final String title;
  final String message;
  final String type;

  const FarmAlert({required this.title, required this.message, required this.type});
}

/// Port of services/alertService.js
/// Uses a global navigatorKey (set in main.dart) to show dialogs.
class AlertService {
  AlertService._();
  static final AlertService instance = AlertService._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Timer? _interval;
  DateTime? _lastAlertTime;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getString('lastAlertTime');
      _lastAlertTime = last != null ? DateTime.tryParse(last) : null;
      _initialized = true;
      _startAlertChecker();
    } catch (e) {
      debugPrint('Error initializing alert service: $e');
    }
  }

  void _startAlertChecker() {
    _interval?.cancel();
    _interval = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkAndShowAlert();
    });
  }

  Future<void> _checkAndShowAlert() async {
    final now = DateTime.now();
    if (_lastAlertTime == null ||
        now.difference(_lastAlertTime!) >= const Duration(minutes: 10)) {
      await showRandomAlert();
      _lastAlertTime = now;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastAlertTime', now.toIso8601String());
    }
  }

  static const List<FarmAlert> _alerts = [
    FarmAlert(title: '💧 Irrigation Reminder', message: "Don't forget to check your soil moisture! Your crops may need water.", type: 'irrigation'),
    FarmAlert(title: '🌾 Fertilizer Alert', message: 'Time to check NPK levels! Your soil might need nutrients.', type: 'fertilizer'),
    FarmAlert(title: '💧 Water Your Crops', message: 'Your fields are getting dry! Consider irrigation today.', type: 'irrigation'),
    FarmAlert(title: '🧪 Nutrient Check Needed', message: 'Check your soil nutrients! Add fertilizer if needed.', type: 'fertilizer'),
    FarmAlert(title: '🌱 Crop Care Alert', message: 'Your crops need attention! Check soil moisture and nutrients.', type: 'general'),
    FarmAlert(title: '💦 Irrigation Time', message: 'Optimal time for watering! Check your soil moisture levels.', type: 'irrigation'),
    FarmAlert(title: '🌿 Fertilizer Reminder', message: 'Your soil nutrients may be low! Consider adding fertilizer.', type: 'fertilizer'),
  ];

  Future<FarmAlert> showRandomAlert() async {
    final randomAlert = _alerts[Random().nextInt(_alerts.length)];
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
          title: Text(randomAlert.title),
          content: Text(randomAlert.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                navigatorKey.currentState?.pushNamed('SensorData');
              },
              child: const Text('View Sensors'),
            ),
          ],
        ),
      );
    }
    return randomAlert;
  }

  Future<void> showImmediateAlert([String type = 'random']) async {
    if (type == 'random') {
      await showRandomAlert();
      return;
    }
    final specific = type == 'fertilizer'
        ? const FarmAlert(title: '🌾 Fertilizer Needed', message: 'Your soil nutrients are low! Add fertilizer today.', type: 'fertilizer')
        : const FarmAlert(title: '💧 Irrigation Needed', message: 'Your soil moisture is low! Water your crops soon.', type: 'irrigation');
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
          title: Text(specific.title),
          content: Text(specific.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void stop() {
    _interval?.cancel();
    _interval = null;
  }

  Future<void> resetAlertTime() async {
    _lastAlertTime = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastAlertTime');
  }

  String getTimeUntilNextAlert() {
    if (_lastAlertTime == null) return '0 minutes';
    final now = DateTime.now();
    final timeSince = now.difference(_lastAlertTime!);
    final timeUntil = const Duration(minutes: 10) - timeSince;
    if (timeUntil.isNegative) return 'Any moment now';
    return '${timeUntil.inMinutes} minutes';
  }
}
