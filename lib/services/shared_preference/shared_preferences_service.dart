import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _prefs;

  SharedPreferencesService._();

  static Future<SharedPreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Remember Me functionality
  Future<void> setRememberMe(bool value) async {
    await _prefs?.setBool('remember_me', value);
  }

  bool getRememberMe() {
    return _prefs?.getBool('remember_me') ?? false;
  }

  // User session token
  Future<void> setUserToken(String token) async {
    await _prefs?.setString('user_token', token);
  }

  String? getUserToken() {
    return _prefs?.getString('user_token');
  }

  Future<void> clearUserToken() async {
    await _prefs?.remove('user_token');
  }

  // User info for session management
  Future<void> setUserInfo({
    required String uid,
    required String email,
  }) async {
    await _prefs?.setString('user_uid', uid);
    await _prefs?.setString('user_email', email);
  }

  Map<String, String?> getUserInfo() {
    return {
      'uid': _prefs?.getString('user_uid'),
      'email': _prefs?.getString('user_email'),
    };
  }

  Future<void> clearUserInfo() async {
    await _prefs?.remove('user_uid');
    await _prefs?.remove('user_email');
  }

  // First time app launch
  Future<void> setFirstTimeLaunch(bool value) async {
    await _prefs?.setBool('first_time_launch', value);
  }

  bool isFirstTimeLaunch() {
    return _prefs?.getBool('first_time_launch') ?? true;
  }

  // Clear all user data on logout
  Future<void> clearAllUserData() async {
    await clearUserToken();
    await clearUserInfo();
    await setRememberMe(false);
  }
}