import 'package:book_rental_system/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;

  final ValueNotifier<List<Map<String, String>>> booksNotifier = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> ordersNotifier = ValueNotifier([]);

  // The master list is now correctly and permanently populated.
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
    {
      'image': 'assets/images/dune.jpg',
      'title': 'Dune',
      'author': 'Frank Herbert',
      'genre': 'Science Fiction',
      'description': 'A young nobleman becomes a leader on a desert planet filled with political conflict.',
    },
    {
      'image': 'assets/images/ender_game.jpg',
      'title': "Ender's Game",
      'author': 'Orson Scott Card',
      'genre': 'Science Fiction',
      'description': 'Gifted children train in a futuristic battle school to defend Earth from alien threats.',
    },
    {
      'image': 'assets/images/the_book_thief.jpg',
      'title': 'The Book Thief',
      'author': 'Markus Zusak',
      'genre': 'Historical Fiction',
      'description': 'A girl in Nazi Germany finds comfort in stolen books while death narrates her story.',
    },
    {
      'image': 'assets/images/all_the_light_we_cannot_see.jpg',
      'title': 'All the Light We Cannot See',
      'author': 'Anthony Doerr',
      'genre': 'Historical Fiction',
      'description': 'A blind French girl and a German boy struggle to survive during World War II.',
    },
    {
      'image': 'assets/images/harry_potter_sorcerer_stone.jpg',
      'title': 'Harry Potter and the Sorcerer\'s Stone',
      'author': 'J.K. Rowling',
      'genre': 'Fantasy',
      'description': 'A boy learns he is a wizard and begins his magical journey at Hogwarts.',
    },
    {
      'image': 'assets/images/the_hobbit.jpg',
      'title': 'The Hobbit',
      'author': 'J.R.R. Tolkien',
      'genre': 'Fantasy',
      'description': 'Bilbo Baggins joins dwarves on a quest to reclaim their treasure from a dragon.',
    },
    {
      'image': 'assets/images/me_before_you.jpg',
      'title': 'Me Before You',
      'author': 'Jojo Moyes',
      'genre': 'Romance',
      'description': 'A young woman becomes a caregiver to a paralyzed man, changing both of their lives.',
    },
    {
      'image': 'assets/images/pride_and_prejudice.jpg',
      'title': 'Pride and Prejudice',
      'author': 'Jane Austen',
      'genre': 'Romance',
      'description': 'Elizabeth Bennet navigates love, family, and social expectations in Regency England.',
    },
    {
      'image': 'assets/images/gone_girl.jpg',
      'title': 'Gone Girl',
      'author': 'Gillian Flynn',
      'genre': 'Thriller',
      'description': 'A husband becomes the main suspect when his wife mysteriously disappears.',
    },
    {
      'image': 'assets/images/shutter_island.jpg',
      'title': 'Shutter Island',
      'author': 'Dennis Lehane',
      'genre': 'Thriller',
      'description': 'Two U.S. marshals investigate a psychiatric facility on a remote island.',
    },
    {
      'image': 'assets/images/into_the_wild.jpg',
      'title': 'Into the Wild',
      'author': 'Jon Krakauer',
      'genre': 'Adventure',
      'description': 'A young man abandons society to trek into the Alaskan wilderness.',
    },
    {
      'image': 'assets/images/life_of_pi.jpg',
      'title': 'Life of Pi',
      'author': 'Yann Martel',
      'genre': 'Adventure',
      'description': 'A boy survives a shipwreck and forms an unlikely bond with a tiger on a lifeboat.',
    },
    {
      'image': 'assets/images/atomic_habits.jpg',
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'genre': 'Personal Development',
      'description': 'A guide to building good habits through small daily improvements.',
    },
    {
      'image': 'assets/images/grit.jpg',
      'title': 'Grit',
      'author': 'Angela Duckworth',
      'genre': 'Personal Development',
      'description': 'Explores how passion and perseverance predict long-term success.',
    },
    {
      'image': 'assets/images/the_power_of_now.jpg',
      'title': 'The Power of Now',
      'author': 'Eckhart Tolle',
      'genre': 'Self-Help',
      'description': 'Teaches the importance of living in the present moment to achieve inner peace.',
    },
    {
      'image': 'assets/images/how_to_win_friends.jpg',
      'title': 'How to Win Friends and Influence People',
      'author': 'Dale Carnegie',
      'genre': 'Self-Help',
      'description': 'A timeless guide on communication, relationships, and influencing others.',
    },
  ];

  DataService._internal() {
    booksNotifier.value = _allBooks;
    ordersNotifier.value = [];
  }

  void addBook(Map<String, String> book) {
    final currentBooks = List<Map<String, String>>.from(booksNotifier.value);
    currentBooks.insert(0, book);
    booksNotifier.value = currentBooks;
  }

  void updateBook(int index, Map<String, String> updatedBook) {
    final currentBooks = List<Map<String, String>>.from(booksNotifier.value);
    currentBooks[index] = updatedBook;
    booksNotifier.value = currentBooks;
  }

  void deleteBook(int index) {
    final currentBooks = List<Map<String, String>>.from(booksNotifier.value);
    final String deletedBookTitle = currentBooks[index]['title']!;
    currentBooks.removeAt(index);
    booksNotifier.value = currentBooks;

    final currentOrders = List<Map<String, dynamic>>.from(ordersNotifier.value);
    currentOrders.removeWhere((order) => order['title'] == deletedBookTitle);
    ordersNotifier.value = currentOrders;
  }

  void addOrder(Map<String, String> book, double price, User user) {
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final newOrder = {
      'id': 'BRK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'image': book['image']!,
      'title': book['title']!,
      'author': book['author']!,
      'date': formattedDate,
      'price': price,
      'status': 'Pending',
      'user': user.fullName,
    };
    final currentOrders = List<Map<String, dynamic>>.from(ordersNotifier.value);
    currentOrders.insert(0, newOrder);
    ordersNotifier.value = currentOrders;
  }

  void updateOrderStatus(int orderIndex) {
    final currentOrders = List<Map<String, dynamic>>.from(ordersNotifier.value);
    final order = currentOrders[orderIndex];
    final currentStatus = order['status'];
    String nextStatus;
    switch (currentStatus) {
      case 'Pending':
        nextStatus = 'Rented';
        break;
      case 'Rented':
        nextStatus = 'Returned';
        break;
      case 'Returned':
        nextStatus = 'Pending';
        break;
      default:
        nextStatus = 'Pending';
    }
    currentOrders[orderIndex]['status'] = nextStatus;
    ordersNotifier.value = currentOrders;
  }

  int getOrderStatusCount(String status) {
    return ordersNotifier.value.where((order) => order['status'] == status).length;
  }

  bool isBookRented(String bookTitle) {
    return ordersNotifier.value.any((order) =>
        order['title'] == bookTitle &&
        (order['status'] == 'Rented' || order['status'] == 'Pending' || order['status'] == 'Overdue'));
  }
}
