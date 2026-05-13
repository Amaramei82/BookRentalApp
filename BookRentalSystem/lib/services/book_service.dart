import 'dart:convert';
import 'package:book_rental_system/models/book_model.dart';
import 'package:http/http.dart' as http;

class BookService {
  static const String apiUrl = "http://192.168.100.1/book-rental-website/api/books.php";

  Future<List<Book>> fetchAvailableBooks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Book.fromJson(item)).toList();
      } else {
        throw "Failed to load books";
      }
    } catch (e) {
      throw "Connection error: $e";
    }
  }
}