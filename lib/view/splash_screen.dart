import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/services/splash_service.dart';

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
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.3,
            colors: [
              Color(0xFF2D5980), // Dark blue at center
              Color(0xFF4A7BA7), // Medium blue
              Color(0xFF6B9BC9), // Lighter blue
              Color(0xFFFFFFFF), // White at edges
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
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