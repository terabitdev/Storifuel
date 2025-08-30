import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:storifuel/services/firebase/auth_service.dart';
import 'package:storifuel/services/shared_preference/shared_preferences_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  late SharedPreferencesService _prefsService;
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  User? _currentUser;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;
  bool get isFirstTimeLaunch => _prefsService.isFirstTimeLaunch();

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      // Initialize SharedPreferences service
      _prefsService = await SharedPreferencesService.getInstance();
      
      // Initialize current user
      _currentUser = _authService.currentUser;
      
      // Listen to auth state changes
      _authService.authStateChanges.listen((User? user) async {
        _currentUser = user;
        
        if (user != null) {
          // User is signed in - validate and save user info
          try {
            // Validate the user token to ensure account still exists
            await user.reload();
            final token = await user.getIdToken(true);
            
            // Always save user session data
            await _prefsService.setUserToken(token!);
            await _prefsService.setUserInfo(
              uid: user.uid,
              email: user.email ?? '',
            );
            
            // print('Auth state: User signed in - ${user.email}');
          } catch (e) {
            // print('Auth state: User token validation failed - $e');
            // If token validation fails, sign out
            _currentUser = null;
            await _prefsService.clearAllUserData();
          }
        } else {
          // User is signed out - clear saved data
          // print('Auth state: User signed out');
          await _prefsService.clearAllUserData();
        }
        
        notifyListeners();
      });
      
      // Check for existing session
      await _checkExistingSession();
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // print('Error initializing auth: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _checkExistingSession() async {
    try {
      final userToken = _prefsService.getUserToken();
      final userInfo = _prefsService.getUserInfo();
      
      if (userToken != null && userInfo['uid'] != null) {
        // If we have a stored token but no current user, validate the token
        if (_currentUser == null) {
          // print('No current user but token exists, waiting for Firebase auth state...');
          // Wait a bit for Firebase to restore the session
          await Future.delayed(const Duration(seconds: 2));
        }
        
        // If we have a current user, validate the token is still valid
        if (_currentUser != null) {
          await _validateUserToken();
        } else {
          // If still no user after waiting, clear stored data
          // print('Token exists but user not restored, clearing stored data');
          await _prefsService.clearAllUserData();
          notifyListeners();
        }
      }
    } catch (e) {
      // print('Error checking existing session: $e');
      await _prefsService.clearAllUserData();
      notifyListeners();
    }
  }

  Future<void> _validateUserToken() async {
    try {
      if (_currentUser != null) {
        // Force reload user data from Firebase
        await _currentUser!.reload();
        
        // Try to get a fresh token - this will fail if account is deleted
        await _currentUser!.getIdToken(true);
        
        // print('Token validation successful for user: ${_currentUser!.email}');
      }
    } catch (e) {
      // print('Token validation failed: $e');
      // Token is invalid (account deleted, disabled, etc.)
      await signOut();
    }
  }

  // Method to mark app as launched (called after onboarding)
  Future<void> setFirstTimeLaunchCompleted() async {
    await _prefsService.setFirstTimeLaunch(false);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }


  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );
      
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_authService.getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // The auth state listener will handle saving the token and user info
      // if remember me is enabled
      
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_authService.getErrorMessage(e.code));
      return false;
    } catch (e) {
      // print('Unexpected sign-in error: $e');
      _setError('An unexpected error occurred: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _authService.sendPasswordResetEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_authService.getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // The auth state listener will automatically clear all user data
    // when user becomes null
    notifyListeners();
  }

  // Public method to validate current user token
  Future<bool> validateCurrentUser() async {
    if (_currentUser == null) return false;
    
    try {
      await _currentUser!.reload();
      await _currentUser!.getIdToken(true);
      return true;
    } catch (e) {
      // print('User validation failed: $e');
      await signOut();
      return false;
    }
  }
}
