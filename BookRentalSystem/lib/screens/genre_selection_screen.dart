import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:book_rental_system/theme/color.dart';

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

  // Dynamic fetch from PHP API
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    const String apiUrl = "http://192.168.100.1/book-rental-website/api/api_get_categories.php";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load genres');
    }
  }

  // Assigns aesthetic icons/colors to dynamic categories
  IconData _getIconForGenre(String name) {
    if (name.contains('Sci')) return Icons.science_outlined;
    if (name.contains('Hist')) return Icons.history_edu_outlined;
    if (name.contains('Fant')) return Icons.auto_awesome_outlined;
    return Icons.folder_open_outlined; // Default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Browse Genres')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: darkGreen));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _buildGenreCard(context, cat['name']);
            },
          );
        },
      ),
    );
  }

  Widget _buildGenreCard(BuildContext context, String genreName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(_getIconForGenre(genreName), color: darkGreen),
        title: Text(genreName, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          // Your existing filtering logic
          final filteredBooks = widget.allBooks
              .where((book) => book['genre']!.toLowerCase() == genreName.toLowerCase())
              .toList();
          // Navigate to Results Screen...
        },
      ),
    );
  }
}