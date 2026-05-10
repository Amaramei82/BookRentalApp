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
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: const Text('Confirm Your Order', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(widget.book['title']!),
                trailing: Text('\$${basePrice.toStringAsFixed(2)}'),
              ),
              ListTile(
                title: const Text('Condition'),
                trailing: Text(selectedCondition),
              ),
              ListTile(
                title: const Text('Duration'),
                trailing: Text(selectedDuration),
              ),
              const Divider(),
              ListTile(
                title: const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                trailing: Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: darkGreen),
              child: const Text('Confirm Order'),
              onPressed: () {
                widget.onOrderPlaced(widget.book, totalPrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRented = widget.isBookRented(widget.book['title']!);
    final List<String> conditions = ['New', 'Used'];
    final List<String> durations = ['7 days', '14 days', '30 days'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.book['title']!, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 4.0,
                child: SizedBox(
                  height: 300,
                  width: 200,
                  child: Image.asset(
                    widget.book['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.book['title']!,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.book['author']!,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Display the book's description dynamically
            Text(
              widget.book['description'] ?? 'No description available.', // Use the description from the book object
              style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text(widget.book['genre']!),
              backgroundColor: lightGreen.withOpacity(0.2),
              labelStyle: const TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text('Condition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(conditions.length, (index) {
                return ChoiceChip(
                  label: Text(conditions[index]),
                  selected: _selectedCondition == index,
                  selectedColor: darkGreen,
                  labelStyle: TextStyle(
                    color: _selectedCondition == index ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCondition = selected ? index : _selectedCondition;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            const Text('Rental Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(durations.length, (index) {
                return ChoiceChip(
                  label: Text(durations[index]),
                  selected: _selectedDuration == index,
                  selectedColor: darkGreen,
                  labelStyle: TextStyle(
                    color: _selectedDuration == index ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedDuration = selected ? index : _selectedDuration;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: isRented ? Colors.grey : darkGreen,
                ),
                onPressed: isRented ? null : () => _showOrderConfirmation(context),
                child: Text(isRented ? 'Already Rented' : 'Order Now'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
