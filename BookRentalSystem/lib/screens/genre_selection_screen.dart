import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:book_rental_system/screens/book_detail_screen.dart';

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
      // Trying to fetch from the PHP API as defined in the previous version
      const String apiUrl = "http://10.0.2.2/book-rental-website/api/api_get_categories.php";
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.map((e) => e['name'].toString()).toList();
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
    // Fallback: extract unique genres from the local book list
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24), // Dark navbar from design
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
        actions: [
          _buildHeaderLink('Home', onTap: () => Navigator.pop(context)),
          _buildHeaderLink('Book Categories', isSelected: true),
          _buildHeaderLink('Contact Us'),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Section
          Container(
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.bookmark, color: darkGreen, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
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
                              onTap: () => setState(() => _selectedCategory = category),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: isSelected ? darkGreen.withValues(alpha: 0.05) : Colors.transparent,
                                  border: isSelected ? const Border(left: BorderSide(color: darkGreen, width: 4)) : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 16,
                                      color: isSelected ? darkGreen : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected ? darkGreen : Colors.grey.shade700,
                                        ),
                                        maxLines: 2,
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
          // Main Content Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedCategory != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCategory!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(width: 40, height: 3, color: darkGreen),
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
                            mainAxisSpacing: 20,
                          ),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return _BookCard(
                              book: book,
                              onOrderPlaced: widget.onOrderPlaced,
                              isRented: widget.isBookRented(book['title']!),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLink(String title, {bool isSelected = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: onTap ?? () {},
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

class _BookCard extends StatelessWidget {
  final Map<String, String> book;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool isRented;

  const _BookCard({
    required this.book,
    required this.onOrderPlaced,
    required this.isRented,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: 'cat_book_${book['title']}',
                  child: _buildImage(book['image']!),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Column(
              children: [
                Text(
                  book['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  '₹10 / day',
                  style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(
                            book: book,
                            onOrderPlaced: onOrderPlaced,
                            isBookRented: (title) => isRented,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 14, color: Colors.black87),
                    label: const Text('View Details', style: TextStyle(color: Colors.black87, fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: BoxFit.contain);
    } else if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: BoxFit.contain);
    } else {
      return Image.file(File(imagePath), fit: BoxFit.contain);
    }
  }
}
