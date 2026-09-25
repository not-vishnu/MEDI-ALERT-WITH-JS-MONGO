import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Windows/Desktop:
  static const String baseUrl = 'http://localhost:5000/api';

  // If using Android Emulator, change to:
  // static const String baseUrl = 'http://10.0.2.2:5000/api';

  // --------------------------------------------------
  // TOKEN MANAGEMENT
  // --------------------------------------------------

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, String>> _headers() async {
    final token = await getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --------------------------------------------------
  // REGISTER
  // --------------------------------------------------

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
    }

    return data;
  }

  // --------------------------------------------------
  // LOGIN
  // --------------------------------------------------

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
    }

    return data;
  }

  // --------------------------------------------------
  // GET PROFILE
  // --------------------------------------------------

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: await _headers(),
    );

    return jsonDecode(response.body);
  }

  // --------------------------------------------------
  // UPDATE PROFILE
  // --------------------------------------------------

  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: await _headers(),
      body: jsonEncode({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
      }),
    );

    return jsonDecode(response.body);
  }

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------

  static Future<void> logout() async {
    await removeToken();
  }
  // --------------------------------------------------
  // MEDICINES
  // --------------------------------------------------

  /// Get all medicines for the logged-in user
  static Future<Map<String, dynamic>> getMedicines() async {
    final response = await http.get(
      Uri.parse('$baseUrl/medicines'),
      headers: await _headers(),
    );

    return jsonDecode(response.body);
  }

  /// Create a new medicine
  static Future<Map<String, dynamic>> createMedicine({
    required String name,
    required String dosage,
    required String time,
    String status = 'Pending',
    bool reminderEnabled = true,
    int notificationId = 0,
    DateTime? reminderDate,
    String notes = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/medicines'),
      headers: await _headers(),
      body: jsonEncode({
        'name': name,
        'dosage': dosage,
        'time': time,
        'status': status,
        'reminderEnabled': reminderEnabled,
        'notificationId': notificationId,
        'reminderDate': reminderDate?.toIso8601String(),
        'notes': notes,
      }),
    );

    return jsonDecode(response.body);
  }

  /// Update an existing medicine
  static Future<Map<String, dynamic>> updateMedicine(
    String id, {
    String? name,
    String? dosage,
    String? time,
    String? status,
    bool? reminderEnabled,
    int? notificationId,
    DateTime? reminderDate,
    String? notes,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/medicines/$id'),
      headers: await _headers(),
      body: jsonEncode({
        if (name != null) 'name': name,
        if (dosage != null) 'dosage': dosage,
        if (time != null) 'time': time,
        if (status != null) 'status': status,
        if (reminderEnabled != null) 'reminderEnabled': reminderEnabled,
        if (notificationId != null) 'notificationId': notificationId,
        if (reminderDate != null)
          'reminderDate': reminderDate.toIso8601String(),
        if (notes != null) 'notes': notes,
      }),
    );

    return jsonDecode(response.body);
  }

  /// Delete a medicine
  static Future<Map<String, dynamic>> deleteMedicine(
    String id,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/medicines/$id'),
      headers: await _headers(),
    );

    return jsonDecode(response.body);
  }
}
