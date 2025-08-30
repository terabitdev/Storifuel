import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/services/splash/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashService splashService = SplashService();

  @override
  void initState() {
    super.initState();
    splashService.navigateToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF1a3a5c), // Darker blue at top
              Color(0xFF4a6fa5), // Lighter blue in middle
              Color(0xFF1a3a5c), // Darker blue at bottom
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.splash,
                width: 167,
                height: 147,
              ),
            ],
          ),
        ),
      ),
    );
  }
}