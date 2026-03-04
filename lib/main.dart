import 'package:flutter/material.dart';
import 'package:tbcare/features/home/home_page.dart';
import 'package:tbcare/features/jadwal/jadwal_page.dart';
import 'features/splash/splash_page.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_routes.dart';
import 'features/splash/splash_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/forgot_password_page.dart';
import 'features/auth/register_page.dart';
import 'app/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.home: (context) => const MainNavigation(),
        AppRoutes.jadwal: (context) => const JadwalPage(),
      },
    );
  }
}