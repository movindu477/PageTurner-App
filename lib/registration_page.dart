import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _password;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse("http://192.168.170.224/flutter_API/register.php"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"name": _name, "email": _email, "password": _password}),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData['status'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registered Successfully")));
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const LoginPage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(responseData['message'])));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Server error: ${response.statusCode}")));
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Text("Register Page"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/book.png', width: 100, height: 100),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? "Enter your name" : null,
                        onSaved: (value) => _name = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => (value!.isEmpty || !value.contains("@")) ? "Enter valid email" : null,
                        onSaved: (value) => _email = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) => (value!.length < 6) ? "Password must be 6+ chars" : null,
                        onSaved: (value) => _password = value,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: !_obscurePassword,
                            onChanged: (value) {
                              setState(() {
                                _obscurePassword = !value!;
                              });
                            },
                          ),
                          const Text("Show Password"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Register", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const LoginPage())),
                        child: const Text("Already have an account? Login", style: TextStyle(color: Colors.deepPurple)),
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
