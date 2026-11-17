import 'package:flutter/material.dart';
import 'services/alert_service.dart';
import 'screens/landing_screen.dart';
import 'screens/about_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/set_password_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/yield_screen.dart';
import 'screens/recommendation_screen.dart';
import 'screens/farm_info_screen.dart';
import 'screens/sensor_data_screen.dart';
import 'screens/mandi_price_screen.dart';

void main() {
  runApp(const KrishopajApp());
}

class KrishopajApp extends StatelessWidget {
  const KrishopajApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishopaj',
      debugShowCheckedModeBanner: false,
      navigatorKey: AlertService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2ECC71)),
        useMaterial3: true,
      ),
      initialRoute: 'Landing',
      routes: {
        'Landing': (context) => const LandingScreen(),
        'About': (context) => const AboutScreen(),
        'Login': (context) => const LoginScreen(),
        'Signup': (context) => const SignupScreen(),
        'OTP': (context) => const OTPScreen(),
        'SetPassword': (context) => const SetPasswordScreen(),
        'Forgot': (context) => const ForgotPasswordScreen(),
        'Dashboard': (context) => const DashboardScreen(),
        'Chatbot': (context) => const ChatbotScreen(),
        'Yield': (context) => const YieldScreen(),
        'Recommendation': (context) => const RecommendationScreen(),
        'FarmInfo': (context) => const FarmInfoScreen(),
        'SensorData': (context) => const SensorDataScreen(),
        'MandiPrice': (context) => const MandiPriceScreen(),
      },
    );
  }
}
