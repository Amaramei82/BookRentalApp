import 'dart:io';
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

  void _processRental() {
    final int? duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid duration in days.')),
      );
      return;
    }

    const double basePrice = 10.00;
    final double totalPrice = basePrice * duration;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Rental'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Book: ${widget.book['title']}'),
              Text('Duration: $duration days'),
              const Divider(),
              Text('Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: darkGreen),
              onPressed: () {
                widget.onOrderPlaced(widget.book, totalPrice);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRented = widget.isBookRented(widget.book['title']!);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
          _buildHeaderLink('Home'),
          _buildHeaderLink('Book Categories'),
          _buildHeaderLink('Contact Us'),
          _buildHeaderLink('My Orders'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.account_circle, color: Colors.white70, size: 20),
                  SizedBox(width: 4),
                  Text('User', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Image and Details Card
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side: Book Cover
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildImage(widget.book['image']!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Right Side: Details
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book['title']!,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1),
                          const SizedBox(height: 24),
                          _buildDetailRow('ISBN:', '978-9-35-141670-8'), // Matches image
                          _buildDetailRow('Author:', widget.book['author']!),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              const Text(
                                '₹10',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '(Per Day)',
                                style: TextStyle(color: Colors.black54, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Duration Input and Rent Button Section
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_filled, size: 18, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Enter duration (in days)',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: TextField(
                                          controller: _durationController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: isRented ? null : _processRental,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isRented ? Colors.grey : darkGreen,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        isRented ? 'Rented' : 'Proceed to Rent',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Short Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notes, color: Colors.black, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Short Description',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    widget.book['description'] ?? 'No description available for this book.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1F2937))),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 15, color: Color(0xFF4B5563))),
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
