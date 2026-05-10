import 'dart:ui';
import 'package:book_rental_system/services/data_service.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            const Text('BookRent Admin', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gen_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<List<Map<String, String>>>(
                  valueListenable: _dataService.booksNotifier,
                  builder: (context, books, child) {
                    return ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: _dataService.ordersNotifier,
                      builder: (context, orders, child) {
                        return GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            _StatCard(
                              title: 'Total Books',
                              value: books.length.toString(),
                              color: darkGreen,
                            ),
                            _StatCard(
                              title: 'Active Rentals',
                              value: _dataService.getOrderStatusCount('Rented').toString(),
                              color: Colors.blue,
                            ),
                            _StatCard(
                              title: 'Pending Orders',
                              value: _dataService.getOrderStatusCount('Pending').toString(),
                              color: Colors.orange,
                            ),
                            _StatCard(
                              title: 'Overdue Books',
                              value: _dataService.getOrderStatusCount('Overdue').toString(),
                              color: Colors.red,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Activities',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: _dataService.ordersNotifier,
                  builder: (context, orders, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length > 4 ? 4 : orders.length,
                      itemBuilder: (context, index) {
                        final activity = orders[index];
                        return _ActivityTile(
                          icon: _getIconForStatus(activity['status']!),
                          text: "${activity['user']} ${activity['status']!.toLowerCase()} '${activity['title']}'",
                          time: activity['date']!,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'Rented':
        return Icons.book_online;
      case 'Returned':
        return Icons.history;
      case 'Pending':
        return Icons.shopping_cart_checkout;
      default:
        return Icons.book;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Add a slight shadow to lift the card
      color: Colors.white, // Make card solid white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyle(color: color, fontSize: 14)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String time;
  const _ActivityTile({required this.icon, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.white.withOpacity(0.9),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700),
        title: Text(text),
        subtitle: Text(time),
      ),
    );
  }
}
