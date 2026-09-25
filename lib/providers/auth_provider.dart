import 'package:flutter/material.dart';

import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;

  Map<String, dynamic>? user;

  bool get isLoggedIn => user != null;

  // --------------------------------------------------
  // LOGIN
  // --------------------------------------------------

  Future<String?> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await ApiService.login(
        email: email,
        password: password,
      );

      if (response['success'] == true) {
        user = response['user'];
        return null;
      }

      return response['message'] ?? 'Login failed';
    } catch (e) {
      return 'Unable to connect to server: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------
  // REGISTER
  // --------------------------------------------------

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      if (response['success'] == true) {
        user = response['user'];
        return null;
      }

      return response['message'] ?? 'Registration failed';
    } catch (e) {
      return 'Unable to connect to server: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
Future<void> refreshProfile() async {
  try {
    final response = await ApiService.getProfile();

    if (response['success'] == true) {
      user = response['user'];
      notifyListeners();
    }
  } catch (e) {
    debugPrint('Failed to refresh profile: $e');
  }
}

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------

  Future<void> logout() async {
    await ApiService.logout();

    user = null;

    notifyListeners();
  }

  // --------------------------------------------------
  // LOAD CURRENT USER
  // --------------------------------------------------

  Future<void> loadUser() async {
    try {
      final token = await ApiService.getToken();

      if (token == null) {
        user = null;
        notifyListeners();
        return;
      }

      final response = await ApiService.getProfile();

      if (response['success'] == true) {
        user = response['user'];
      } else {
        await ApiService.removeToken();
        user = null;
      }
    } catch (e) {
      user = null;
    }

    notifyListeners();
  }
}