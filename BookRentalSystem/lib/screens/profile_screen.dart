import 'package:book_rental_system/screens/login_screen.dart';
import 'package:book_rental_system/theme/color.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.fullName ?? "Anamae Villazon Cubihano");
    emailController = TextEditingController(text: widget.user?.email ?? "anamae.cubihano@gmail.com");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header inspired by Screenshot 2026-05-14 003158.png
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: const [
                  Icon(Icons.person_pin, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Update your personal information", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildInputField(nameController, "Full Name", Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildInputField(emailController, "Email Address", Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildInputField(TextEditingController(text: "9876543210"), "Phone", Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _buildInputField(TextEditingController(), "Current Password", Icons.lock_outline, isPass: true),
                  const SizedBox(height: 30),
                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Update Profile", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginScreen())),
                    child: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController ctrl, String label, IconData icon, {bool isPass = false}) {
    return TextField(
      controller: ctrl,
      obscureText: isPass,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: darkGreen),
        hintText: label,
        filled: true,
        fillColor: const Color(0xFFF1F4F8), // Matching screenshot grey background
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}