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

    const double basePrice = 9.99;
    final double totalPrice = basePrice * selectedMultiplier;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: darkGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: darkGreen, size: 32),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Confirm Your Order',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildOrderRow('Book', widget.book['title']!),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildOrderRow('Condition', selectedCondition),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildOrderRow('Duration', selectedDuration),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildOrderRow('Base Price', '\$${basePrice.toStringAsFixed(2)}'),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildTotalRow('Total Amount', '\$${totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: Colors.grey.shade400),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: darkGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
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
                          child: const Text('Confirm Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkGreen),
          ),
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.book['title']!,
          style: const TextStyle(color: darkGreen, fontWeight: FontWeight.bold, letterSpacing: -0.3),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkGreen),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Book cover with animation
            Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.9 + (value * 0.1),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 320,
                      width: 220,
                      child: Image.asset(
                        widget.book['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Title, author, genre
            Text(
              widget.book['title']!,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  widget.book['author']!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: lightGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                widget.book['genre']!,
                style: const TextStyle(color: darkGreen, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            // Description
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.3),
            ),
            const SizedBox(height: 8),
            Text(
              widget.book['description'] ?? 'No description available.',
              style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            // Condition section
            const Text('Condition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: List.generate(conditions.length, (index) {
                return ChoiceChip(
                  label: Text(conditions[index]),
                  selected: _selectedCondition == index,
                  selectedColor: darkGreen,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: _selectedCondition == index ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: _selectedCondition == index ? Colors.transparent : Colors.grey.shade300),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedCondition = selected ? index : _selectedCondition;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 24),
            // Rental Duration section
            const Text('Rental Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: List.generate(durations.length, (index) {
                return ChoiceChip(
                  label: Text(durations[index]),
                  selected: _selectedDuration == index,
                  selectedColor: darkGreen,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: _selectedDuration == index ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: _selectedDuration == index ? Colors.transparent : Colors.grey.shade300),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedDuration = selected ? index : _selectedDuration;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 40),
            // Order button with gradient when enabled
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: isRented ? null : () => _showOrderConfirmation(context),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: isRented
                        ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                        : const LinearGradient(
                      colors: [darkGreen, Color(0xFF2E7D64)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isRented
                        ? []
                        : [
                      BoxShadow(
                        color: darkGreen.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      isRented ? 'Already Rented' : 'Order Now',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}