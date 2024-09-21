// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:convert'; // Added for JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminLoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(context) {
    return Column(
      children: [
        Text("Admin Login",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Text("Enter your credentials to login as Admin"),
      ],
    );
  }

  Widget _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Admin Username",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Admin Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var response = await _adminLogin(
              _usernameController.text,
              _passwordController.text,
            );

            if (response.statusCode == 200) { 
              // Login success, show success message
              final responseData = jsonDecode(response.body);
              final successSnackBar = SnackBar(
                content: Text('Login successful as Admin ${responseData['message']}!'),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(successSnackBar);

              // Navigate to the admin dashboard
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushNamed(context, '/admin-dashboard');
              });
            } else {
              // Handle login failure
              final errorResponse = jsonDecode(response.body);
              final errorSnackBar = SnackBar(
                content: Text('Failed to login: ${errorResponse['message']}'),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
            }
          },
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(onPressed: () {}, child: Text("Forgot password?"));
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an admin account?"),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text("Sign Up"))
      ],
    );
  }

  Future<http.Response> _adminLogin(String name, String password) {
    // Make sure to replace with your correct API URL
    return http.post(
      Uri.parse('http://192.168.60.176:5000/admin-login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'password': password,
      }),
    );
  }
}