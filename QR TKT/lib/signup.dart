import 'package:flutter/material.dart';
import 'package:flutter_frontend/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State to manage password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFFcaf0f8), // Pale Blue
                Color.fromARGB(255, 255, 255, 255), // White
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signupButton(context),
              _login(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: const [
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF03045e), // Dark Navy
          ),
        ),
        Text(
          "Fill in the details to sign up",
          style: TextStyle(color: Color(0xFF0077b6)), // Deep Blue
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFFcaf0f8), // Pale Blue Background
            filled: true,
            prefixIcon: Icon(Icons.person, color: Color(0xFF0077b6)), // Deep Blue Icon
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible, // Control password visibility
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFFcaf0f8), // Pale Blue Background
            filled: true,
            prefixIcon: Icon(Icons.lock, color: Color(0xFF0077b6)), // Deep Blue Icon
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFF0077b6), // Deep Blue Icon
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _signupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var response = await _registerUser(
          _usernameController.text,
          _passwordController.text,
        );
        if (response.statusCode == 201) {
          final successSnackBar = SnackBar(
            content: const Text('Registration successful!'),
            backgroundColor: const Color(0xFF00b4d8), // Bright Blue
          );
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);

          // Navigate to the login page after a delay
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushNamed(context, '/login');
          });
        } else {
          final errorSnackBar = SnackBar(
            content: Text('Failed to register: ${response.body}'),
            backgroundColor: Colors.red, // Red for error messages
          );
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(), backgroundColor: const Color(0xFF03045e),
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 75), // Dark Navy Button Background
      ),
      child: Text(
        "Sign Up",
        style: GoogleFonts.robotoMono(
          fontSize: 20,
          color: Colors.white, // White Text Color
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<http.Response> _registerUser(String name, String password) {
    return http.post(
      Uri.parse('${url}register'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'password': password,
        'ticket': {
          'loc1': '',
          'loc2': '',
          'cost': 0,
          'issueDate': DateTime.now().toIso8601String(),
        },
      }),
    );
  }

  Widget _login(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: Color(0xFF0077b6)), // Deep Blue
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            "Login",
            style: TextStyle(color: Color(0xFF03045e)), // Dark Navy
          ),
        ),
      ],
    );
  }
}
