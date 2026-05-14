import 'package:book_rental_system/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;

  final ValueNotifier<List<Map<String, String>>> booksNotifier = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> ordersNotifier = ValueNotifier([]);

  final List<Map<String, String>> _allBooks = const [
    {
      'image': 'assets/images/midnight_library.jpg',
      'title': 'The Midnight Library',
      'author': 'Matt Haig',
      'genre': 'Science Fiction',
      'description': 'A woman enters a magical library where each book shows a different version of her life.',
    },
    {
      'image': 'assets/images/project_hail_mary.jpg',
      'title': 'Project Hail Mary',
      'author': 'Andy Weir',
      'genre': 'Science Fiction',
      'description': 'A lone astronaut must save humanity after waking up on a mysterious space mission.',
    },
    {
      'image': 'assets/images/where_the_crawdads_sing.jpg',
      'title': 'Where the Crawdads Sing',
      'author': 'Delia Owens',
      'genre': 'Historical Fiction',
      'description': 'A young girl raised in the marsh becomes the prime suspect in a local murder.',
    },
    {
      'image': 'assets/images/circe.jpg',
      'title': 'Circe',
      'author': 'Madeline Miller',
      'genre': 'Fantasy',
      'description': 'A retelling of the myth of Circe, the witch-goddess who discovers her own power.',
    },
    {
      'image': 'assets/images/the_seven_husbands_of_evelyn_hugo.jpg',
      'title': 'The Seven Husbands of Evelyn Hugo',
      'author': 'Taylor Jenkins Reid',
      'genre': 'Romance',
      'description': 'An aging Hollywood icon reveals the truth behind her glamorous life and seven marriages.',
    },
    {
      'image': 'assets/images/the_silent_patient.jpg',
      'title': 'The Silent Patient',
      'author': 'Alex Michaelides',
      'genre': 'Thriller',
      'description': 'A woman stops speaking after shooting her husband, and a therapist seeks the truth.',
    },
  ];

  DataService._internal() {
    booksNotifier.value = _allBooks;
    ordersNotifier.value = [];
  }

  void addOrder({
    required Map<String, String> book,
    required double price,
    required User user,
    String duration = '1 day',
    String address = 'Not Provided',
    String paymentMethod = 'COD',
  }) {
    final now = DateTime.now();
    final formattedDate = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    
    final newOrder = {
      'id': '#${now.millisecondsSinceEpoch.toString().substring(10)}',
      'image': book['image']!,
      'title': book['title']!,
      'author': book['author']!,
      'date': formattedDate,
      'price': price,
      'duration': duration,
      'address': address,
      'payment_method': paymentMethod,
      'status': 'Pending',
      'payment_status': 'success',
      'user': user.fullName,
    };
    
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
