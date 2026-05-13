import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  // ANDROID EMULATOR URL
  static const String baseUrl =
      "http://10.0.2.2/book-rental-website/api";

  /// GET BOOKS
  static Future<List<dynamic>> getBooks() async {

    final response = await http.get(
      Uri.parse("$baseUrl/books.php"),
    );

    print(response.body);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data['data'];

    } else {

      throw Exception("Failed to load books");
    }
  }

  /// LOGIN
  static Future<dynamic> login(
      String email,
      String password,
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/users.php"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  /// PLACE ORDER
  static Future<void> placeOrder({
    required int userId,
    required int bookId,
    required String address,
  }) async {

    final response = await http.post(
      Uri.parse("$baseUrl/place_order.php"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "user_id": userId,
        "book_id": bookId,
        "address": address,
        "payment_method": "Cash",
      }),
    );

    print(response.body);
  }
}