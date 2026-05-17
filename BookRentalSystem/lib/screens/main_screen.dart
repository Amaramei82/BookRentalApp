import 'package:book_rental_system/screens/home_screen.dart';
import 'package:book_rental_system/services/auth_service.dart';
import 'package:book_rental_system/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({
    super.key,
    required this.user,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DataService _dataService = DataService();

  final TextEditingController _searchController =
  TextEditingController();

  int _selectedIndex = 0;

  List<Map<String, String>> _filteredBooks = [];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _filteredBooks = _dataService.booksNotifier.value;

    _dataService.booksNotifier.addListener(_updateBooks);

    _searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    _dataService.booksNotifier.removeListener(_updateBooks);

    _searchController.dispose();

    super.dispose();
  }

  void _updateBooks() {
    setState(() {
      _filterBooks();
    });
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase();

    final allBooks = _dataService.booksNotifier.value;

    setState(() {
      _searchQuery = _searchController.text;

      _filteredBooks = query.isEmpty
          ? allBooks
          : allBooks.where((book) {
        final title =
        (book['title'] ?? '').toLowerCase();

        final author =
        (book['author'] ?? '').toLowerCase();

        final genre =
        (book['genre'] ?? '').toLowerCase();

        return title.contains(query) ||
            author.contains(query) ||
            genre.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return PopScope(
      canPop: false,
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _dataService.ordersNotifier,
        builder: (context, confirmedOrders, child) {
          return ValueListenableBuilder<List<Map<String, String>>>(
            valueListenable: _dataService.booksNotifier,
            builder: (context, allBooks, child) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF5F7FA),
                        Color(0xFFE9EDF2),
                      ],
                    ),
                  ),
                  child: HomeScreen(
                    searchController: _searchController,
                    filteredBooks: _filteredBooks,
                    allBooks: allBooks,

                    // FIXED HERE
                    currentUser: {
                      "id": widget.user.id,
                      "name": widget.user.fullName,
                      "email": widget.user.email,
                    },

                    onOrderPlaced:
                        (
                        book,
                        price, {
                      duration,
                      address,
                      paymentMethod,
                    }) =>
                        _dataService.addOrder(
                          book: book,
                          price: price,
                          user: widget.user,
                          duration: duration ?? '1 day',
                          address:
                          address ?? 'Not Provided',
                          paymentMethod:
                          paymentMethod ?? 'COD',
                        ),

                    isBookRented:
                    _dataService.isBookRented,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}