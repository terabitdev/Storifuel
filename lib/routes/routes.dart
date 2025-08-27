import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view/onboarding_screen.dart';
import 'package:storifuel/view/sign_in_screen.dart';
import 'package:storifuel/view/sign_up_screen.dart';
import 'package:storifuel/view/splash_screen.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case RoutesName.onboarding:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OnboardingScreen(),
        );
      case RoutesName.signIn:
        return MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (_) => AuthProvider(), 
            child: SignInScreen(),
          ),
        );

      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUpScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route defined"))),
        );
    }
  }
}
