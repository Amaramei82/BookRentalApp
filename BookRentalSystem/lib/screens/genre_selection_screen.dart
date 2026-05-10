import 'package:book_rental_system/screens/search_results_screen.dart';
import 'package:flutter/material.dart';

class GenreSelectionScreen extends StatelessWidget {
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;
  // It now accepts the master book list from the parent
  final List<Map<String, String>> allBooks;

  const GenreSelectionScreen({
    super.key,
    required this.onOrderPlaced,
    required this.isBookRented,
    required this.allBooks, // Added required parameter
  });

  final List<String> genres = const [
    'Science Fiction',
    'Historical Fiction',
    'Fantasy',
    'Romance',
    'Thriller',
    'Adventure',
    'Personal Development',
    'Self-Help',
  ];

  // The local book list has been removed.

  void _navigateToGenreResults(BuildContext context, String selectedGenre) {
    // It now filters the master list passed from the parent.
    final List<Map<String, String>> filteredBooks = allBooks
        .where((book) => book['genre']!.toLowerCase() == selectedGenre.toLowerCase())
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          searchQuery: selectedGenre,
          searchResults: filteredBooks,
          onOrderPlaced: onOrderPlaced,
          isBookRented: isBookRented,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genres'),
      ),
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: ListTile(
              title: Text(genre),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _navigateToGenreResults(context, genre);
              },
            ),
          );
        },
      ),
    );
  }
}
