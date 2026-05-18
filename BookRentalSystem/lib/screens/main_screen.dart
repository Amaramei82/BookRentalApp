import 'package:book_rental_system/screens/home_screen.dart';
import 'package:book_rental_system/screens/orders_screen.dart';
import 'package:book_rental_system/screens/profile_screen.dart';
import 'package:book_rental_system/screens/search_results_screen.dart';
import 'package:book_rental_system/services/auth_service.dart';
import 'package:book_rental_system/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _dataService = DataService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredBooks = [];

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
      _filteredBooks = query.isEmpty
          ? allBooks
          : allBooks.where((book) {
        final title = (book['title'] ?? '').toString().toLowerCase();
        final author = (book['author'] ?? '').toString().toLowerCase();
        final genre = (book['genre'] ?? '').toString().toLowerCase();
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
          return ValueListenableBuilder<List<Map<String, dynamic>>>(
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
                    // GI-FIX: Safe-casting gikan sa dynamic padulong Map<String, String> para sa HomeScreen
                    filteredBooks: _filteredBooks.map((b) => b.map((k, v) => MapEntry(k, v.toString()))).toList(),
                    allBooks: allBooks.map((b) => b.map((k, v) => MapEntry(k, v.toString()))).toList(),
                    currentUser: widget.user,
                    onOrderPlaced: (book, price) => _dataService.addOrder(
                      book: book, // Dawaton ra ni sa DataService kay gi-cast na nato didto
                      price: price,
                      user: widget.user,
                      duration: '1 day',
                      address: 'Not Provided',
                      paymentMethod: 'COD',
                    ),
                    isBookRented: _dataService.isBookRented,
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