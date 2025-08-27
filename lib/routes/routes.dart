import 'package:flutter/material.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text("No Route defined"),
                  ),
                ));
    }
  }
}