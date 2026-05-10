import 'dart:io';
import 'package:book_rental_system/screens/book_detail_screen.dart';
import 'package:book_rental_system/screens/genre_selection_screen.dart';
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
    final List<Map<String, String>> recentlyAddedBooks = allBooks.length > 4 ? allBooks.sublist(4) : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore_outlined, color: Colors.black, size: 28),
            tooltip: 'Browse Genres',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GenreSelectionScreen(
                    onOrderPlaced: onOrderPlaced,
                    isBookRented: isBookRented,
                    allBooks: allBooks,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.85), // Subtle white layer
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title, author, or genre...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true, // Add a fill color for better visibility
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Browse Books'),
                const SizedBox(height: 16),
                _buildBookCarousel(filteredBooks, context),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Recently Added'),
                const SizedBox(height: 16),
                _buildBookCarousel(recentlyAddedBooks, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Ensure title is visible
          ),
    );
  }

  Widget _buildBookCarousel(List<Map<String, String>> books, BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return SizedBox(
            width: 170,
            child: _BookCard(
              book: book,
              onOrderPlaced: onOrderPlaced,
              isRented: isBookRented(book['title']!),
            ),
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
    return GestureDetector(
      onTap: () {
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
      child: Card(
        margin: const EdgeInsets.only(right: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0, // Add more elevation for visibility
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: book['image']!.startsWith('assets/')
                      ? Image.asset(
                          book['image']!,
                          width: double.infinity,
                          fit: BoxFit.cover)
                      : Image.file(
                          File(book['image']!),
                          width: double.infinity,
                          fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book['author']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isRented)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    'Rented',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
