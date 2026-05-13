import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String? id;
  final String fullName;
  final String email;
  final String mobile;

  User({this.id, required this.fullName, required this.email, required this.mobile});

  // Helper to create a User object from JSON returned by the PHP API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      fullName: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}

class AuthService {
  // Replace with your actual IP (use 10.0.2.2 for Android Emulator)
  static const String baseUrl = "http://10.0.2.2:3001";

  // SINGELTON PATTERN
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // REGISTER USER
  Future<String> registerUser({
    required String fullName,
    required String email,
    required String password,
    String mobile = "0000000000",
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"), // Removed .php
        headers: {"Content-Type": "application/json"}, // Tell Node.js we are sending JSON
        body: json.encode({ // Use json.encode for Node.js compatibility
          'name': fullName,
          'email': email,
          'mobile': mobile,
          'password': password,
        }),
      );

      final data = json.decode(response.body);
      // Node.js returns { success: true }, not { status: 'success' }
      return data['success'] == true ? 'Success' : data['message'];
    } catch (e) {
      print("Registration Error: $e"); // Check your debug console for specific errors
      return "Connection error. Please try again.";
    }
  }

  // LOGIN USER
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"), // Removed .php
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) { // Check for 'success' boolean
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}