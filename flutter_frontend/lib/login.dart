import 'dart:convert'; // Added for JSON encoding
import 'package:flutter/material.dart';
import 'package:flutter_frontend/dummy.dart'; // Assuming this is where MyHomePage is located
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
          margin: const EdgeInsets.all(24),
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
    return const Column(
      children: [
        Text("Welcome Back",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Text("Enter your credentials to login"),
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
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
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
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(onPressed: () {}, child: const Text("Forgot password?"));
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text("Sign Up"))
      ],
    );
  }

  Future<void> _loginUser(String name, String password) async {
    var res = await http.post(
      Uri.parse('http://192.168.37.176:5000/login'),
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
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        
        // Navigate to the next page with the token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(token: mytoken)),
        );
      } else {
        final errorSnackBar = SnackBar(
          content: Text('Login failed: ${jsonres['message']}'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      }
    } else {
      final errorSnackBar = SnackBar(
        content: Text('Failed to login: ${res.body}'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }
}
