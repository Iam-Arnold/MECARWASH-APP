import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loggedInKey = "isLoggedIn";

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Log in user by setting the logged-in state
  Future<void> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
  }

  // Log out user by resetting the logged-in state
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }
}
