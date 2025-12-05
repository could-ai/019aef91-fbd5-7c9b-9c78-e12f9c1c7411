import 'package:flutter/material.dart';
import 'package:couldai_user_app/core/theme/app_theme.dart';
import 'package:couldai_user_app/features/auth/screens/register_screen.dart';
import 'package:couldai_user_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:couldai_user_app/features/home/screens/home_screen.dart';

void main() {
  runApp(const CookApp());
}

class CookApp extends StatelessWidget {
  const CookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook', // Brand name never translated
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Start with Register flow for this demo
      initialRoute: '/register',
      routes: {
        '/': (context) => const RegisterScreen(), // Default route safety
        '/register': (context) => const RegisterScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
