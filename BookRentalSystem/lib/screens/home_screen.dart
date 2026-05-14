import 'dart:io';
import 'package:book_rental_system/screens/book_detail_screen.dart';
import 'package:book_rental_system/screens/genre_selection_screen.dart';
import 'package:book_rental_system/screens/profile_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController searchController;
  final List<Map<String, String>> filteredBooks;
  final List<Map<String, String>> allBooks;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;
  final dynamic currentUser; // Pass user object here

  const HomeScreen({
    super.key,
    required this.searchController,
    required this.filteredBooks,
    required this.allBooks,
    required this.onOrderPlaced,
    required this.isBookRented,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24), // Navbar color from Screenshot 2026-05-14 130408.png
        elevation: 4,
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/images/logo.png', height: 35),
                const Spacer(),
                // Integrated Search Bar
                Container(
                  width: 180,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'Search Title...',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6), // Blue search button
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Profile Dropdown Style
                _buildProfileLink(context),
              ],
            ),
            const Divider(color: Colors.white12, height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildNavButton(Icons.home, 'Home', isSelected: true),
                  _buildNavButton(Icons.menu_book, 'Book Categories', onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GenreSelectionScreen(
                        onOrderPlaced: onOrderPlaced,
                        isBookRented: isBookRented,
                        allBooks: allBooks,
                      ),
                    ));
                  }),
                  _buildNavButton(Icons.email, 'Contact Us'),
                  _buildNavButton(Icons.shopping_bag, 'My Orders'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroBanner(),
            const SizedBox(height: 30),
            _buildSectionTitle(Icons.collections_bookmark, 'New Arrivals'),
            const SizedBox(height: 20),
            _buildBookGrid(filteredBooks, context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, {bool isSelected = false, VoidCallback? onTap}) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: isSelected ? Colors.redAccent : Colors.white),
      label: Text(label, style: TextStyle(color: isSelected ? Colors.redAccent : Colors.white, fontSize: 12)),
    );
  }

  Widget _buildProfileLink(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileScreen(user: currentUser),
        ));
      },
      child: Row(
        children: const [
          Icon(Icons.account_circle, color: Colors.white, size: 24),
          SizedBox(width: 4),
          Text('Amara', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/home_background.jpg'), fit: BoxFit.cover),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('RENT BOOKS', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text(
              'Renting books saves you time, money,\nshelf space and the environment.',
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1E40AF), size: 24),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
          ],
        ),
        const SizedBox(height: 4),
        Container(width: 60, height: 3, color: Colors.blueAccent),
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
          childAspectRatio: 0.7,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) => _BookCard(
          book: books[index],
          onOrderPlaced: onOrderPlaced,
          isRented: isBookRented(books[index]['title']!),
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Map<String, String> book;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool isRented;

  const _BookCard({required this.book, required this.onOrderPlaced, required this.isRented});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Expanded(child: Padding(padding: const EdgeInsets.all(8), child: Image.asset(book['image']!, fit: BoxFit.contain))),
          Text(book['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
          const Text('₹10 / day', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}