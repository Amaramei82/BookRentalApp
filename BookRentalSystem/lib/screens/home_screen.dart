import 'dart:io';
import 'package:book_rental_system/screens/book_detail_screen.dart';
import 'package:book_rental_system/screens/genre_selection_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController searchController;
  final List<Map<String, String>> filteredBooks;
  final List<Map<String, String>> allBooks;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;

  const HomeScreen({
    super.key,
    required this.searchController,
    required this.filteredBooks,
    required this.allBooks,
    required this.onOrderPlaced,
    required this.isBookRented,
  });

  @override
  Widget build(BuildContext context) {
    // Partition books for "New Arrivals" and "Most Viewed" based on the design
    final List<Map<String, String>> newArrivals = allBooks.length > 4 ? allBooks.sublist(0, 4) : allBooks;
    final List<Map<String, String>> mostViewed = allBooks.length > 8 ? allBooks.sublist(4, 8) : (allBooks.length > 4 ? allBooks.sublist(4) : []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24), // Matching the dark navbar in the design
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const Spacer(),
            _buildHeaderLink('Home', isSelected: true),
            _buildHeaderLink('Categories', onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GenreSelectionScreen(
                    onOrderPlaced: onOrderPlaced,
                    isBookRented: isBookRented,
                    allBooks: allBooks,
                  ),
                ),
              );
            }),
            _buildHeaderLink('Contact'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Section
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/home_background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.black.withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RENT BOOKS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Renting books saves you time,\nmoney, shelf space and the\nenvironment.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Text(
                                '₹',
                                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('TIME', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            const Text('MONEY', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            const Text('SHELF SPACE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            const Text('ENVIRONMENT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            // Search Bar Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search by Title or Author...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6), // Blue search button as per design
                      borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // New Arrivals Section
            _buildSectionHeader(Icons.library_books, 'New Arrivals'),
            const SizedBox(height: 20),
            _buildBookGrid(newArrivals, context),

            const SizedBox(height: 40),

            // Most Viewed Section
            _buildSectionHeader(Icons.local_fire_department, 'Most Viewed'),
            const SizedBox(height: 20),
            _buildBookGrid(mostViewed.isEmpty ? filteredBooks : mostViewed, context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderLink(String title, {bool isSelected = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.redAccent : Colors.white, //Design shows a red tint for active links
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1E40AF), size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E40AF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: 80,
          height: 3,
          color: const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  Widget _buildBookGrid(List<Map<String, String>> books, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _BookCard(
            book: book,
            onOrderPlaced: onOrderPlaced,
            isRented: isBookRented(book['title']!),
          );
        },
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
          // Book cover with padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: 'book_${book['title']}',
                child: _buildImage(book['image']!),
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
                const SizedBox(height: 10),
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
