import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class User {
  final String? id;
  final String fullName;
  final String email;
  final String mobile;

  User({this.id, required this.fullName, required this.email, required this.mobile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      fullName: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'].toString(),
    );
  }
}

class AuthService {
  static const String baseUrl = "http://192.168.100.16:3001";

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<String> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String mobile,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': fullName.trim(),
          'email': email.trim().toLowerCase(), // Force match with lowercasing
          'mobile': mobile.trim(),
          'password': password.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data['success'] == true ? 'Success' : (data['message'] ?? 'Registration failed');
      } else {
        // Correctly capture structural error messages from the backend
        return data['message'] ?? data['error'] ?? "Server error: ${response.statusCode}";
      }
    } on TimeoutException {
      return "Connection timed out. Check your IP address and Server status.";
    } catch (e) {
      return "Connection error: $e";
    }
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email.trim().toLowerCase(),
          'password': password.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null;
    }
  }
}