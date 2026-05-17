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
        backgroundColor: const Color(0xFF1A1F24), // Dark top bar from design
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const Spacer(),
            _buildHeaderLink('Home'),
            _buildHeaderLink('Book Categories'),
            _buildHeaderLink('Contact Us'),
            _buildHeaderLink('My Orders', isSelected: true),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // "My Orders" Heading with icon
            Center(
              child: Column(
                children: [
                  const Icon(Icons.shopping_bag, size: 40, color: Color(0xFF1E40AF)),
                  const SizedBox(height: 12),
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Tabular Orders List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 48),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            _buildHeaderCell('ORDER ID', 100),
                            _buildHeaderCell('ORDER DATE', 120),
                            _buildHeaderCell('BOOK NAME', 220),
                            _buildHeaderCell('PRICE', 100),
                            _buildHeaderCell('DURATION', 100),
                            _buildHeaderCell('ADDRESS', 200),
                            _buildHeaderCell('PAYMENT METHOD', 180),
                            _buildHeaderCell('PAYMENT STATUS', 150),
                            _buildHeaderCell('ORDER STATUS', 150),
                            _buildHeaderCell('ACTION', 100),
                          ],
                        ),
                      ),
                      // Table Rows
                      if (orders.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Center(child: Text('No orders found.', style: TextStyle(color: Colors.grey))),
                        )
                      else
                        ...orders.map((order) => _buildOrderRow(order)).toList(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),

            // Big Footer Section from design
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderLink(String title, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.redAccent : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String label, double width) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildOrderRow(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade200),
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(order['id'].toString(), 100),

          _buildDataCell(
            order['date']?.toString() ?? '-',
            120,
          ),

          _buildDataCell(
            order['book_name']?.toString() ?? '-',
            220,
            isBold: true,
          ),

          _buildDataCell(
            '₹${order['price']?.toString() ?? '0'}',
            100,
          ),

          _buildDataCell(
            order['duration']?.toString() ?? '1 day',
            100,
          ),

          _buildDataCell(
            order['address']?.toString() ?? 'Not Provided',
            200,
          ),

          _buildDataCell(
            order['payment_method']?.toString() ?? 'COD',
            180,
          ),

          SizedBox(
            width: 150,
            child: _buildBadge(
              order['payment_status']?.toString() ?? 'Pending',
              const Color(0xFFD1FAE5),
              const Color(0xFF065F46),
            ),
          ),

          SizedBox(
            width: 150,
            child: _buildBadge(
              order['status_name']?.toString() ?? 'Pending',
              const Color(0xFFDBEAFE),
              const Color(0xFF1E40AF),
            ),
          ),

          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(String value, double width, {bool isBold = false}) {
    return SizedBox(
      width: width,
      child: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text.toLowerCase(),
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1F24),
      padding: const EdgeInsets.fromLTRB(40, 60, 40, 40),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branding
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/logo.png', height: 40),
                        const SizedBox(width: 10),
                        const Text('Book Rental', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Online Books for rent', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                    const SizedBox(height: 20),
                    const Text(
                      'Rent novels, academic & bestsellers at affordable prices.',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Explore
              _buildFooterCol('Explore', ['Home', 'Categories', 'About Us', 'Contact']),
              const SizedBox(width: 40),
              // Legal
              _buildFooterCol('Legal', ['Terms & Conditions', 'Privacy Policy']),
              const SizedBox(width: 40),
              // Connect
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Connect', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildIconText(Icons.email, 'contact@bookrental.com'),
                    const SizedBox(height: 10),
                    _buildIconText(Icons.phone, '+91 1234567890'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.facebook),
                        const SizedBox(width: 10),
                        _buildSocialIcon(Icons.camera_alt),
                        const SizedBox(width: 10),
                        _buildSocialIcon(Icons.alternate_email),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          const Text('© 2026 Book Rental. All Rights Reserved.', style: TextStyle(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFooterCol(String title, List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(e, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              )),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(color: Colors.white54, fontSize: 13)),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white70, size: 18),
    );
  }
}
