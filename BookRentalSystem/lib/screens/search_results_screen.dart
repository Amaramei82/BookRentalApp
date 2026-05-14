import 'dart:io';
import 'package:book_rental_system/screens/book_detail_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final List<Map<String, String>> searchResults;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
    required this.searchResults,
    required this.onOrderPlaced,
    required this.isBookRented,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24), // Dark top bar from design
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
        actions: [
          _buildHeaderLink('Home'),
          _buildHeaderLink('Book Categories'),
          _buildHeaderLink('Contact Us'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header Section: "Search Results"
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search, size: 36, color: Color(0xFF1E40AF)),
                      const SizedBox(width: 12),
                      const Text(
                        'Search Results',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Showing results for: "$searchQuery"',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 60,
                    height: 3,
                    color: const Color(0xFF3B82F6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Result Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Icon(Icons.bookmark, size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    'Found ${searchResults.length} book(s)',
                    style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Results Grid
            searchResults.isEmpty ? _buildEmptyState() : _buildResultsGrid(context),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.64,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
        ),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final book = searchResults[index];
          return _BookCard(
            book: book,
            onOrderPlaced: onOrderPlaced,
            isRented: isBookRented(book['title']!),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No books found for this search.', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () {},
        child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
                  tag: 'search_book_${book['title']}',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 12, color: Colors.black54),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        book['author']!,
                        style: const TextStyle(color: Colors.black54, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
