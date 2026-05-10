import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final double totalPrice;

  const OrdersScreen({super.key, required this.orders, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Orders', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: orders.isEmpty
                ? const Center(
                    child: Text('You have no orders yet.', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _OrderItemCard(order: order);
                    },
                  ),
          ),
          // Display the total price at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Rented:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: darkGreen, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderItemCard({required this.order});

  @override
  Widget build(BuildContext context) {
    // ... (rest of the _OrderItemCard widget remains the same)
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            _buildImageWithStatus(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(order['author']!, style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text(order['date']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '\$${(order['price'] as double).toStringAsFixed(2)}',
              style: const TextStyle(color: darkGreen, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithStatus() {
    Color statusColor;
    switch (order['status']) {
      case 'Rented':
        statusColor = Colors.blue;
        break;
      case 'Returned':
        statusColor = Colors.green;
        break;
      case 'Overdue':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            order['image']!,
            width: 80,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Text(
            order['status']!,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
