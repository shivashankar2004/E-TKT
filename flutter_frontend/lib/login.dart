import 'dart:convert'; // Added for JSON encoding
import 'package:flutter/material.dart';
import 'package:flutter_frontend/config.dart';
import 'package:flutter_frontend/currLoc.dart'; // Assuming this is where MyHomePage is located
import 'package:flutter_frontend/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedprefs();
  }

  void initSharedprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFcaf0f8), // Pale Blue
                Color.fromARGB(255, 255, 255, 255), // Soft Blue
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
        Text(
          "Welcome Back",
          style: GoogleFonts.roboto(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF03045e), // Dark Navy
          ),
        ),
        Text(
          "Enter your credentials to login",
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: Color(0xFF0077b6), // Deep Blue
          ),
        ),
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
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFFcaf0f8), // Pale Blue Background for Input Fields
            filled: true,
            prefixIcon: Icon(Icons.person, color: Color(0xFF0077b6)), // Deep Blue Icon
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFFcaf0f8), // Pale Blue Background for Input Fields
            filled: true,
            prefixIcon: Icon(Icons.lock, color: Color(0xFF0077b6)), // Deep Blue Icon
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _loginUser(
              _usernameController.text,
              _passwordController.text,
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(), backgroundColor: Color(0xFF03045e),
            padding: const EdgeInsets.symmetric(vertical: 16), // Dark Navy Button Background
          ),
          child: Text(
            "Login",
            style: GoogleFonts.robotoMono(
              fontSize: 20,
              color: Colors.white, // White Text Color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Forgot password?",
        style: GoogleFonts.roboto(
          color: Color(0xFF03045e), // Dark Navy Text Color
        ),
      ),
    );
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: GoogleFonts.roboto(
            color: Color(0xFF0077b6), // Deep Blue
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: Text(
            "Sign Up",
            style: GoogleFonts.roboto(
              color: Color(0xFF03045e), // Dark Navy Text Color
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loginUser(String name, String password) async {
    var res = await http.post(
      Uri.parse('http://192.168.1.4:5555/login'),
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
          'issueDate': DateTime.now().toIso8601String(),
        },
      }),
    );

    if (res.statusCode == 200) {
      var jsonres = jsonDecode(res.body);
      if (jsonres['status']) {
        var mytoken = jsonres['token'];
        await prefs.setString('token', mytoken);
        const successSnackBar = SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Color(0xFF00b4d8), // Bright Blue
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackBar);

        // Navigate to the next page with the token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()),
        );
      } else {
        final errorSnackBar = SnackBar(
          content: Text('Login failed: ${jsonres['message']}'),
          backgroundColor: Color(0xFF0077b6), // Deep Blue
        );
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      }
    } else {
      final errorSnackBar = SnackBar(
        content: Text('Failed to login: ${res.body}'),
        backgroundColor: Color(0xFF0077b6), // Deep Blue
      );
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }
}
