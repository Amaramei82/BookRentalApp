import 'dart:convert';

import 'package:book_rental_system/screens/genre_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersScreen extends StatefulWidget {
  final List<Map<String, String>> allBooks;
  final Function(Map<String, String>, double) onOrderPlaced;
  final bool Function(String) isBookRented;

  const OrdersScreen({
    super.key,
    required this.allBooks,
    required this.onOrderPlaced,
    required this.isBookRented,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> orders = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.114:3001/orders"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        setState(() {
          orders = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });

        print(data);
      } else {
        setState(() {
          isLoading = false;
        });

        print("FAILED TO LOAD ORDERS");
      }
    } catch (e) {
      print("FETCH ORDER ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24),
        elevation: 2,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 35,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            _buildHeaderLink(
              'Home',
              context,
              onTap: () {
                Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                );
              },
            ),

            _buildHeaderLink(
              'Book Categories',
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GenreSelectionScreen(
                      onOrderPlaced: widget.onOrderPlaced,
                      isBookRented: widget.isBookRented,
                      allBooks: widget.allBooks,
                    ),
                  ),
                );
              },
            ),

            _buildHeaderLink(
              'My Orders',
              context,
              isSelected: true,
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            Center(
              child: Column(
                children: const [
                  Icon(
                    Icons.shopping_bag,
                    size: 40,
                    color: Color(0xFF1E40AF),
                  ),

                  SizedBox(height: 12),

                  Text(
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),

              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Container(
                  constraints: BoxConstraints(
                    minWidth:
                    MediaQuery.of(context).size.width - 48,
                  ),

                  child: Column(
                    children: [

                      // TABLE HEADER
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,

                          borderRadius:
                          const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),

                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),

                        child: Row(
                          children: [
                            _buildHeaderCell(
                              'ORDER ID',
                              120,
                            ),

                            _buildHeaderCell(
                              'ORDER DATE',
                              220,
                            ),

                            _buildHeaderCell(
                              'BOOK NAME',
                              300,
                            ),

                            _buildHeaderCell(
                              'PRICE',
                              120,
                            ),
                          ],
                        ),
                      ),

                      // LOADING
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        )

                      // EMPTY
                      else if (orders.isEmpty)
                        Container(
                          width:
                          MediaQuery.of(context).size.width -
                              48,

                          padding: const EdgeInsets.all(50),

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),

                            borderRadius:
                            const BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                          ),

                          child: const Center(
                            child: Text(
                              'No orders found.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )

                      // DATA
                      else
                        ...orders
                            .map(
                              (order) =>
                              _buildOrderRow(order),
                        )
                            .toList(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderLink(
      String title,
      BuildContext context, {
        bool isSelected = false,
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),

      child: TextButton(
        onPressed: onTap ?? () {},

        child: Text(
          title,

          style: TextStyle(
            color:
            isSelected
                ? Colors.redAccent
                : Colors.white,

            fontWeight:
            isSelected
                ? FontWeight.bold
                : FontWeight.normal,

            fontSize: 13,
          ),
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
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),

      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade200),
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),

      child: Row(
        children: [

          // ORDER ID
          _buildDataCell(
            order['id']?.toString() ?? '-',
            120,
          ),

          // ORDER DATE
          _buildDataCell(
            order['date']?.toString() ?? '-',
            220,
          ),

          // BOOK NAME
          _buildDataCell(
            order['book_name']?.toString() ?? '-',
            300,
            isBold: true,
          ),

          // PRICE
          _buildDataCell(
            '₹${order['price']?.toString() ?? '0'}',
            120,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(
      String value,
      double width, {
        bool isBold = false,
      }) {
    return SizedBox(
      width: width,

      child: Text(
        value,

        style: TextStyle(
          fontSize: 14,

          fontWeight:
          isBold
              ? FontWeight.bold
              : FontWeight.normal,

          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }
}