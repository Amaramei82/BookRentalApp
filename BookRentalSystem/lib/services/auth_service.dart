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
  static const String baseUrl = "http://192.168.100.1/book_rental/api";

  // SINGELTON PATTERN
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // REGISTER USER
  Future<String> registerUser({
    required String fullName,
    required String email,
    required String password,
    String mobile = "0000000000", // Default value if UI doesn't have it yet
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {
          'name': fullName,
          'email': email,
          'mobile': mobile,
          'password': password,
        },
      );

      final data = json.decode(response.body);
      return data['status'] == 'success' ? 'Success' : data['message'];
    } catch (e) {
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
        Uri.parse("$baseUrl/login.php"),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}