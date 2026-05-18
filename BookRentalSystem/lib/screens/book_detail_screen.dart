import 'dart:io';
import 'package:book_rental_system/screens/checkout_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, String> book;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.onOrderPlaced,
    required this.isBookRented,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final TextEditingController _durationController = TextEditingController(text: '1');

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _navigateToCheckout() {
    final int? duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid duration (number of days).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          book: widget.book,
          duration: duration,
          onOrderPlaced: widget.onOrderPlaced,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gigamit ang title gikan sa DataService para i-check kung rented ba
    final bool isRented = widget.isBookRented(widget.book['title'] ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: const Text('Book Details', style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Book Cover - Base sa image path gikan sa server
                    Center(
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildImage(widget.book['image'] ?? ''),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Book Info gikan sa DataService mapping
                    Text(
                      widget.book['title'] ?? 'Unknown Title',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By ${widget.book['author'] ?? 'Unknown Author'}',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(widget.book['genre'] ?? 'General'),
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 30),
                    _buildDetailRow('ISBN:', '978-9-35-141670-8'), // Pwede nimo i-update kung naay ISBN sa API
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('₹10', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        SizedBox(width: 4),
                        Text('(Per Day)', style: TextStyle(color: Colors.black54, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Rental Section
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text('Duration (Days)', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _durationController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: isRented ? null : _navigateToCheckout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isRented ? Colors.grey : darkGreen,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text(isRented ? 'Already Rented' : 'Rent Now', style: const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Description Section gikan sa DataService mapping
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    widget.book['description'] ?? 'Walay description nga nakit-an.',
                    style: const TextStyle(fontSize: 15, color: Color(0xFF4B5563), height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(width: 5),
        Text(value, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _buildImage(String imagePath) {
    const String baseUrl = "http://192.168.1.114:3001/"; // I-add kini

    if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 50, color: Colors.grey));
    } else if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    } else if (imagePath.isNotEmpty && !imagePath.startsWith('assets')) {
      // Kini para sa images gikan sa server
      return Image.network(
        baseUrl + imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    } else {
      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
    }
  }
}