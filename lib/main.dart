import 'package:flutter/material.dart';
import 'registration_page.dart'; // Import the registration page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      ),
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}

/// Splash Screen with Logo
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the registration page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.deepPurple, // Background color of the splash screen
      body: Center(
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10), // Adjust the radius as needed
          child: Image.asset(
            'assets/images/book.png', // Path to your image
            width: 150, // Adjust the size as needed
            height: 150,
          ),
        ),
      ),
    );
  }
}
