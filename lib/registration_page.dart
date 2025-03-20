import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the LoginPage

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;
  final bool _isPasswordVisible = false; // For password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        iconTheme: IconThemeData(),
        title: const Text("Welcome To Register Page"),
        centerTitle: true,
        leading: null,
        automaticallyImplyLeading: false, // Center the title
      ),
      body: Center(
        // Center the form on the screen
        child: SingleChildScrollView(
          // Make the form scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10, // Add shadow (higher value = larger shadow)
              shadowColor: Colors.deepPurple.withOpacity(0.3), // Custom shadow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Minimize the column size
                    children: [
                      Image.asset(
                        'assets/images/book.png',
                        width: 100,
                        height: 100,
                      ),
                      // Full Name Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 15, 15) // gap
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                        onSaved: (value) => _name = value,
                      ),
                      const SizedBox(height: 20), // Added spacing

                      // Email Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(), // Added border
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains("@")) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value,
                      ),
                      const SizedBox(height: 20), // Added spacing

                      // Password Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(), // Added border
                        ),
                        obscureText: !_isPasswordVisible, // Toggle obscureText
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value,
                      ),
                      const SizedBox(height: 20), // Added spacing

                      // Register Button
                      SizedBox(
                        width: double.infinity, // Full-width button
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Optionally, navigate to another page after registration
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.pop(context); // Go back to the previous screen
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple, // Button background color
                            foregroundColor: Colors.white, // Text color
                            padding: const EdgeInsets.symmetric(vertical: 16), // Button height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // "Already have an account? Login" Text
                      TextButton(
                        onPressed: () {
                          // Navigate to LoginPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}