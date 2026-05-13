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
  int _selectedCondition = 0;
  int _selectedDuration = 0;

  void _showOrderConfirmation(BuildContext context) {
    final List<String> conditions = ['New', 'Used'];
    final List<String> durations = ['7 days', '14 days', '30 days'];
    final List<double> durationMultipliers = [1.0, 1.5, 2.2];

    final String selectedCondition = conditions[_selectedCondition];
    final String selectedDuration = durations[_selectedDuration];
    final double selectedMultiplier = durationMultipliers[_selectedDuration];

    const double basePrice = 10.00;
    final double totalPrice = basePrice * selectedMultiplier;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.receipt_long_rounded, color: darkGreen, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Confirm Your Order',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildOrderRow('Book', widget.book['title']!),
                _buildOrderRow('Condition', selectedCondition),
                _buildOrderRow('Duration', selectedDuration),
                const Divider(),
                _buildOrderRow('Total Amount', '₹${totalPrice.toStringAsFixed(2)}', isBold: true),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isBold ? Colors.black : Colors.black54, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRented = widget.isBookRented(widget.book['title']!);
    final List<String> conditions = ['New', 'Used'];
    final List<String> durations = ['7 days', '14 days', '30 days'];

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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Image and Details
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildImage(widget.book['image']!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Details
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book['title']!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('ISBN:', '978-1-61-268019-4'), // Placeholder as in design
                          _buildDetailRow('Author:', widget.book['author']!),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Text(
                                '₹10',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '(Per Day)',
                                style: TextStyle(color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: isRented ? null : () => _showOrderConfirmation(context),
                            icon: const Icon(Icons.calendar_month, color: Colors.white, size: 18),
                            label: Text(isRented ? 'Already Rented' : 'Rent this book', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Rental Selection Section (Condition and Duration)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Rental Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: darkGreen)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChoiceSection('Condition', conditions, _selectedCondition, (val) => setState(() => _selectedCondition = val)),
                      const SizedBox(width: 24),
                      _buildChoiceSection('Duration', durations, _selectedDuration, (val) => setState(() => _selectedDuration = val)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Short Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notes, color: Colors.black, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Short Description',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    widget.book['description'] ?? 'No description available for this book.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildChoiceSection(String title, List<String> options, int selectedIndex, Function(int) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(options.length, (index) {
            final isSelected = selectedIndex == index;
            return ChoiceChip(
              label: Text(options[index], style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12)),
              selected: isSelected,
              selectedColor: darkGreen,
              onSelected: (selected) => onSelected(index),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            );
          }),
        ),
      ],
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
