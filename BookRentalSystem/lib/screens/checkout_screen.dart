import 'package:book_rental_system/screens/order_confirmed_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, String> book;
  final int duration;
  final Function(Map<String, String>, double) onOrderPlaced;

  const CheckoutScreen({
    super.key,
    required this.book,
    required this.duration,
    required this.onOrderPlaced,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _pinCodeController = TextEditingController();

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double rentPricePerDay = 10.0;
    final double totalRent = rentPricePerDay * widget.duration;
    const double securityDeposit = 150.0;
    final double totalAmount = totalRent + securityDeposit;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F24),
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
        title: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart, size: 32, color: darkGreen),
                  SizedBox(width: 12),
                  Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: darkGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Shipping Address
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.local_shipping, color: darkGreen, size: 20),
                              SizedBox(width: 8),
                              Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildTextField('Address Line 1', 'Street, House No., Area', _addressLine1Controller),
                          const SizedBox(height: 16),
                          _buildTextField('Address Line 2 (Optional)', 'Landmark, Near by', _addressLine2Controller),
                          const SizedBox(height: 16),
                          _buildTextField('Pin Code', '246401', _pinCodeController, keyboardType: TextInputType.number),
                          const SizedBox(height: 24),
                          const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          RadioListTile<String>(
                            value: 'COD',
                            groupValue: 'COD',
                            onChanged: (val) {},
                            title: const Text('Cash on Delivery (COD)'),
                            activeColor: darkGreen,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const Opacity(
                            opacity: 0.5,
                            child: RadioListTile<String>(
                              value: 'Online',
                              groupValue: 'COD',
                              onChanged: null,
                              title: Text('Online Payment (coming soon)'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  widget.onOrderPlaced(widget.book, totalAmount);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => OrderConfirmedScreen(
                                        orderNumber: DateTime.now().millisecondsSinceEpoch.toString().substring(8),
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check_circle, color: Colors.white),
                              label: const Text('Place Your Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Right Column: Summary
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildSummaryCard(totalRent, securityDeposit, totalAmount),
                      const SizedBox(height: 24),
                      _buildTermsCard(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (v) => v!.isEmpty && !label.contains('Optional') ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(double totalRent, double securityDeposit, double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.book, color: darkGreen, size: 18),
              SizedBox(width: 8),
              Text('Your Book', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          Text(widget.book['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          _buildSummaryRow('MRP', '₹250'),
          _buildSummaryRow('Rent Price', '₹10 / day'),
          _buildSummaryRow('Duration', '${widget.duration} days'),
          _buildSummaryRow('Total Rent', '₹${totalRent.toInt()}'),
          _buildSummaryRow('Security Deposit *', '₹${securityDeposit.toInt()}'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: darkGreen)),
              Text('₹${totalAmount.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: darkGreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield, color: darkGreen, size: 18),
              SizedBox(width: 8),
              Text('Deposit Terms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '1. You need to submit a photocopy and show Aadhar Card in original to the delivery person.',
            style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
          ),
          SizedBox(height: 8),
          Text(
            '2. Security Deposit is refundable once we receive the book in proper condition.',
            style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}
