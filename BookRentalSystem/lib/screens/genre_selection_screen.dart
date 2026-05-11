import 'package:book_rental_system/screens/search_results_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class GenreSelectionScreen extends StatelessWidget {
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;
  final List<Map<String, String>> allBooks;

  const GenreSelectionScreen({
    super.key,
    required this.onOrderPlaced,
    required this.isBookRented,
    required this.allBooks,
  });

  final List<Map<String, dynamic>> genres = const [
    {'name': 'Science Fiction', 'icon': Icons.science_outlined, 'color': Color(0xFF4A90E2)},
    {'name': 'Historical Fiction', 'icon': Icons.history_edu_outlined, 'color': Color(0xFF8B6B4D)},
    {'name': 'Fantasy', 'icon': Icons.auto_awesome_outlined, 'color': Color(0xFF9B59B6)},
    {'name': 'Romance', 'icon': Icons.favorite_border, 'color': Color(0xFFE74C3C)},
    {'name': 'Thriller', 'icon': Icons.psychology_outlined, 'color': Color(0xFFE67E22)},
    {'name': 'Adventure', 'icon': Icons.explore_outlined, 'color': Color(0xFF27AE60)},
    {'name': 'Personal Development', 'icon': Icons.self_improvement_outlined, 'color': Color(0xFF3498DB)},
    {'name': 'Self-Help', 'icon': Icons.help_outline, 'color': Color(0xFF1ABC9C)},
  ];

  void _navigateToGenreResults(BuildContext context, String selectedGenre) {
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Browse Genres',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.transparent],
              stops: [0.0, 1.0],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _navigateToGenreResults(context, genre['name']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (genre['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            genre['icon'] as IconData,
                            color: genre['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            genre['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}