// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatelessWidget {
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
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Fill in the details to sign up"),
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
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person),
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
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock),
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
        // Show success message
        final successSnackBar = SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackBar);

        // Navigate to the next screen after a delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamed(context, '/login');
        });
      } else {
        // Show error message
        final errorSnackBar = SnackBar(
          content: Text('Failed to register: ${response.body}'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      }
    },
    child: Text(
      "Sign Up",
      style: TextStyle(fontSize: 20),
    ),
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(vertical: 16),
      minimumSize: Size(150, 56),

    ),
  );
}


  Future<http.Response> _registerUser(String name, String password) {
    return http.post(
      Uri.parse('http://192.168.60.176:5000/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'password': password,
        'ticket': {
          'loc1': '',
          'loc2': '',
          'cost': 0,
          'issueDate': DateTime.now().toIso8601String(), // Format the date correctly
        },
      }),
    );
  }

  Widget _login(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text("Login"),
        ),
      ],
    );
  }
}
