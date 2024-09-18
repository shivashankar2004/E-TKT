import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFcaf0f8), 
                Color.fromARGB(255, 255, 255, 255),
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
      children: [
        Text("Create Account",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03045e),
            )),
        Text("Fill in the details to sign up",
            style: TextStyle(color: Color(0xFF0077b6))),
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
            fillColor: Color(0xFFcaf0f8),
            filled: true,
            prefixIcon: Icon(Icons.person, color: Color(0xFF0077b6)),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFFcaf0f8),
            filled: true,
            prefixIcon: Icon(Icons.lock, color: Color(0xFF0077b6)),
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
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
            content: Text('Registration successful!'),
            backgroundColor: Color(0xFF00b4d8),
          );
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushNamed(context, '/login');
          });
        } else {
          final errorSnackBar = SnackBar(
            content: Text('Failed to register: ${response.body}'),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        }
      },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(), backgroundColor: Color(0xFF03045e),
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
      Uri.parse('http://192.168.37.176:5000/register'),
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
        Text("Already have an account?",
            style: TextStyle(color: Color(0xFF0077b6))),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text(
            "Login",
            style: TextStyle(color: Color(0xFF03045e)),
          ),
        ),
      ],
    );
  }
}
