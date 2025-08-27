import 'dart:async';

import 'package:flutter/widgets.dart';

class SplashService {

  void navigateToHome(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }
}