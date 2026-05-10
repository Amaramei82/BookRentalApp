import 'package:book_rental_system/screens/home_screen.dart';
import 'package:book_rental_system/screens/orders_screen.dart';
import 'package:book_rental_system/screens/profile_screen.dart';
import 'package:book_rental_system/screens/search_results_screen.dart';
import 'package:book_rental_system/services/auth_service.dart';
import 'package:book_rental_system/services/data_service.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _dataService = DataService();
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
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
              final title = book['title']!.toLowerCase();
              final author = book['author']!.toLowerCase();
              final genre = book['genre']!.toLowerCase();
              return title.contains(query) ||
                  author.contains(query) ||
                  genre.contains(query);
            }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _dataService.ordersNotifier,
        builder: (context, confirmedOrders, child) {
          final double totalOrderPrice = confirmedOrders.isEmpty
              ? 0.0
              : confirmedOrders
                  .map((order) => order['price'] as double)
                  .reduce((a, b) => a + b);

          return ValueListenableBuilder<List<Map<String, String>>>(
            valueListenable: _dataService.booksNotifier,
            builder: (context, allBooks, child) {
              final List<Widget> widgetOptions = <Widget>[
                HomeScreen(
                  searchController: _searchController,
                  filteredBooks: _filteredBooks,
                  allBooks: allBooks,
                  onOrderPlaced: (book, price) => _dataService.addOrder(book, price, widget.user),
                  isBookRented: _dataService.isBookRented,
                ),
                SearchResultsScreen(
                  searchQuery: _searchQuery,
                  searchResults: _filteredBooks,
                  onOrderPlaced: (book, price) => _dataService.addOrder(book, price, widget.user),
                  isBookRented: _dataService.isBookRented,
                ),
                OrdersScreen(
                  orders: confirmedOrders,
                  totalPrice: totalOrderPrice,
                ),
                ProfileScreen(user: widget.user),
              ];

              return Scaffold(
                body: Center(
                  child: widgetOptions.elementAt(_selectedIndex),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined), label: 'Home', activeIcon: Icon(Icons.home)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search_outlined), label: 'Search', activeIcon: Icon(Icons.search)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.list_alt_outlined), label: 'Orders', activeIcon: Icon(Icons.list_alt)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline), label: 'Profile', activeIcon: Icon(Icons.person)),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: darkGreen,
                  unselectedItemColor: Colors.grey,
                  onTap: _onItemTapped,
                  showUnselectedLabels: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
