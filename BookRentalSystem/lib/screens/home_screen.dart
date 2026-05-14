import 'dart:io';
import 'package:book_rental_system/screens/book_detail_screen.dart';
import 'package:book_rental_system/screens/genre_selection_screen.dart';
import 'package:book_rental_system/screens/profile_screen.dart';
import 'package:book_rental_system/screens/orders_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController searchController;
  final List<Map<String, String>> filteredBooks;
  final List<Map<String, String>> allBooks;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;
  final dynamic currentUser;

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
      backgroundColor: const Color(0xFFF9FAFB), // Halos puti nga background para mo-pop ang mga cards
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24),
        elevation: 4,
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/images/logo.png', height: 35),
                const Spacer(),
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
                        width: 40,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
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
                  _buildNavButton(Icons.shopping_bag, 'My Orders', onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OrdersScreen(orders: [], totalPrice: 0),
                    ));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSectionTitle(Icons.local_fire_department, 'Most Viewed'),
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

  Widget _buildSectionTitle(IconData icon, String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1E40AF), size: 28),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E40AF))),
          ],
        ),
        const SizedBox(height: 6),
        Container(width: 80, height: 4, color: const Color(0xFF3B82F6)),
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
          childAspectRatio: 0.65, // Gi-adjust para sa dugang button sa ubos
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Book Image Section
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: 'book_${book['title']}',
                  child: _buildImage(book['image']!),
                ),
              ),
            ),
          ),
          // Book Title and Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(
                  book['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF111827)),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹10 / day',
                  style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w900, fontSize: 14),
                ),
                const SizedBox(height: 10),
                // View Details Button
                SizedBox(
                  width: double.infinity,
                  height: 34,
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
                    icon: const Icon(Icons.info_outline, size: 16, color: Color(0xFF1F2937)),
                    label: const Text(
                      'View Details',
                      style: TextStyle(color: Color(0xFF1F2937), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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