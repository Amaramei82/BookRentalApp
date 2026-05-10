import 'package:book_rental_system/screens/book_detail_screen.dart';
import 'package:book_rental_system/services/data_service.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class AdminOrderManagementScreen extends StatefulWidget {
  const AdminOrderManagementScreen({super.key});

  @override
  State<AdminOrderManagementScreen> createState() => _AdminOrderManagementScreenState();
}

class _AdminOrderManagementScreenState extends State<AdminOrderManagementScreen> {
  final DataService _dataService = DataService();

  // Function to navigate to the book's detail screen
  void _viewBookDetails(Map<String, dynamic> order) {
    // Find the full book data from the master list using the title from the order
    final book = _dataService.booksNotifier.value.firstWhere(
      (book) => book['title'] == order['title'],
      orElse: () => <String, String>{}, // Return an empty map if not found
    );

    if (book.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookDetailScreen(
            book: book,
            // Admins can't place orders, so pass a function that shows a message.
            onOrderPlaced: (book, price) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Admins cannot place orders.')),
              );
            },
            // The isRented check still works as intended.
            isBookRented: _dataService.isBookRented,
          ),
        ),
      );
    } else {
      // Show an error if the book from the order can't be found in the master list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book "${order['title']}" not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Management', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _dataService.ordersNotifier,
        builder: (context, orders, child) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              // Pass the navigation function to the card
              return _OrderCard(
                order: order,
                onUpdate: () => _dataService.updateOrderStatus(index),
                onViewDetails: () => _viewBookDetails(order),
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onUpdate;
  final VoidCallback onViewDetails; // Add the new callback

  const _OrderCard({
    required this.order,
    required this.onUpdate,
    required this.onViewDetails,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Rented':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      case 'Returned':
        return Colors.green;
      case 'Overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? 'Unknown';
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: ${order['id'] ?? 'N/A'}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Text(
                  order['date'] ?? 'N/A',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order['user'] ?? 'Unknown User',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Chip(
              label: Text(status),
              backgroundColor: statusColor.withOpacity(0.1),
              labelStyle: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '\$${(order['price'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkGreen),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onUpdate,
                      style: ElevatedButton.styleFrom(backgroundColor: darkGreen),
                      child: const Text('Update Status'),
                    ),
                    const SizedBox(width: 8),
                    // Use the new callback here
                    OutlinedButton(
                      onPressed: onViewDetails,
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
