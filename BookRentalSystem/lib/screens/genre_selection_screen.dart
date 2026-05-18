import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:book_rental_system/screens/book_detail_screen.dart';
import 'package:book_rental_system/screens/orders_screen.dart';

class GenreSelectionScreen extends StatefulWidget {
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;
  final List<Map<String, String>> allBooks;

  const GenreSelectionScreen({
    super.key,
    required this.onOrderPlaced,
    required this.isBookRented,
    required this.allBooks,
  });

  @override
  State<GenreSelectionScreen> createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedCategory;
  List<String> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      const String apiUrl = "http://192.168.1.114:3001/categories";
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.map((e) => e['category'].toString()).toList();
          if (_categories.isNotEmpty) _selectedCategory = _categories[0];
          _isLoadingCategories = false;
        });
      } else {
        _useFallbackCategories();
      }
    } catch (e) {
      _useFallbackCategories();
    }
  }

  void _useFallbackCategories() {
    final genres = widget.allBooks.map((b) => b['genre']!).toSet().toList();
    genres.sort();
    setState(() {
      _categories = genres;
      if (_categories.isNotEmpty) _selectedCategory = _categories[0];
      _isLoadingCategories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = widget.allBooks
        .where((book) => book['genre'] == _selectedCategory)
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24),
        elevation: 2,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 35, fit: BoxFit.contain),
            const Spacer(),
            _buildHeaderLink('Home', onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }),
            _buildHeaderLink('Book Categories', isSelected: true),
            _buildHeaderLink('My Orders', onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OrdersScreen(
                    allBooks: widget.allBooks,
                    onOrderPlaced: widget.onOrderPlaced,
                    isBookRented: widget.isBookRented,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: const [
                    Icon(Icons.bookmark, color: darkGreen, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Categories',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _isLoadingCategories
                    ? const Center(child: CircularProgressIndicator(color: darkGreen))
                    : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? darkGreen.withOpacity(0.05) : Colors.transparent,
                          border: isSelected ? const Border(left: BorderSide(color: darkGreen, width: 4)) : null,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.folder_open, size: 18, color: isSelected ? darkGreen : Colors.grey.shade600),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? darkGreen : Colors.grey.shade700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCategory ?? 'Select Category',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: darkGreen),
                    ),
                    const SizedBox(height: 6),
                    Container(width: 40, height: 3, color: darkGreen),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.filter_list, size: 16, color: Colors.white),
                  label: const Text('Change Category', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(child: Text('No books found in this category'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return _BookCardContainer(
                  book: book,
                  onOrderPlaced: widget.onOrderPlaced,
                  isRented: widget.isBookRented(book['title']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLink(String title, {bool isSelected = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.redAccent : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _BookCardContainer extends StatelessWidget {
  final Map<String, String> book;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool isRented;

  const _BookCardContainer({required this.book, required this.onOrderPlaced, required this.isRented});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: book['image']!.startsWith('http')
                    ? Image.network(book['image']!, fit: BoxFit.contain)
                    : Image.asset(book['image']!, fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Text(book['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                const Text('₹10 / day', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BookDetailScreen(
                          book: book,
                          onOrderPlaced: onOrderPlaced,
                          isBookRented: (title) => isRented,
                        ),
                      ));
                    },
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: const Text('View Details', style: TextStyle(color: Colors.black87, fontSize: 10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}