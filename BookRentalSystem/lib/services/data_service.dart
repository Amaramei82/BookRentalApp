import 'package:book_rental_system/models/book_model.dart';
import 'package:book_rental_system/services/auth_service.dart';
import 'package:book_rental_system/services/book_service.dart';
import 'package:flutter/foundation.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;

  final BookService _bookService = BookService();

  final ValueNotifier<List<Map<String, dynamic>>> booksNotifier = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> ordersNotifier = ValueNotifier([]);

  DataService._internal() {
    ordersNotifier.value = [];
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final List<Book> books = await _bookService.fetchAvailableBooks();

      booksNotifier.value = books.map((book) {
        return {
          'id': book.id.toString(),
          'image': book.image,
          'title': book.title,
          'author': book.author,
          'genre': book.genre,
          'description': book.description,
        };
      }).toList();

      print("BOOKS LOADED: ${booksNotifier.value.length}");
    } catch (e) {
      print("LOAD BOOK ERROR: $e");
    }
  }

  void addOrder({
    required Map<String, dynamic> book, // GI-FIX: Gihimong dynamic aron modawat og bisan unsa gikan sa placement
    required double price,
    required User user,
    String duration = '1 day',
    String address = 'Not Provided',
    String paymentMethod = 'COD',
  }) {
    final now = DateTime.now();

    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.year}";

    final newOrder = {
      'id': '#${now.millisecondsSinceEpoch.toString().substring(10)}',
      'image': book['image'] ?? '',
      'title': book['title'] ?? '',
      'author': book['author'] ?? '',
      'date': formattedDate,
      'price': price,
      'duration': duration,
      'address': address,
      'payment_method': paymentMethod,
      'status': 'Pending',
      'payment_status': 'success',
      'user': user.fullName,
    };

    // GI-FIX: Gihimo kining List<Map<String, dynamic>> aron mosakar ang 'price' (double) ug dili mag-error
    final currentOrders = List<Map<String, dynamic>>.from(ordersNotifier.value);

    currentOrders.insert(0, newOrder);
    ordersNotifier.value = currentOrders;
  }

  bool isBookRented(String bookTitle) {
    return ordersNotifier.value.any((order) =>
    order['title'] == bookTitle &&
        (order['status'] == 'Rented' || order['status'] == 'Pending'));
  }
}