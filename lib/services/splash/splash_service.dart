import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';

class SplashService {

  void navigateToHome(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      final authProvider = context.read<AuthProvider>();
      
      // Wait for auth provider to initialize
      _checkAuthState(context, authProvider);
    });
  }

  Future<void> _checkAuthState(BuildContext context, AuthProvider authProvider) async {
    // If auth provider is not initialized yet, wait a bit more
    if (!authProvider.isInitialized) {
      Timer(const Duration(milliseconds: 500), () {
        _checkAuthState(context, authProvider);
      });
      return;
    }

    // Check auth state and navigate accordingly
    if (authProvider.isSignedIn) {
      // User appears to be signed in, validate the token first
      // print('User appears signed in, validating token...');
      final isValidUser = await authProvider.validateCurrentUser();
      
      if (isValidUser) {
        // Token is valid, user can go to navbar
        // print('Token validation successful, navigating to navbar');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/navbar');
      } else {
        // Token validation failed, user was signed out, check again
        // print('Token validation failed, checking auth state again...');
        // ignore: use_build_context_synchronously
        _checkAuthState(context, authProvider);
      }
    } else if (authProvider.isFirstTimeLaunch) {
      // First time user, show onboarding
      // print('First time user, navigating to onboarding');
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      // Returning user but not signed in, go to sign in
      // print('Returning user not signed in, navigating to sign-in');
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }
}