import 'dart:async';
import 'package:book_rental_system/screens/admin_login_screen.dart';
import 'package:book_rental_system/screens/registration_screen.dart';
import 'package:book_rental_system/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  // No Firebase or special initialization needed.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Rental System',
      theme: lightTheme,
      // The SplashScreen is the correct entry point for the non-Firebase version.
      home: const SplashScreen(),
      routes: {
        '/admin_login': (context) => const AdminLoginScreen(),
      },
    );
  }
}

// The original SplashScreen logic.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png', height: 180),
            const SizedBox(height: 24),
            Text(
              'Your next adventure awaits.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
