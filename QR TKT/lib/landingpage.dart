import 'package:flutter/material.dart';
import 'package:flutter_frontend/login.dart';
import 'package:flutter_frontend/signup.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config.dart';

class LandingPage extends StatelessWidget {
  final String wlcm = "Welcome to the App"; // Example value
  final String nxt = "Let's Get Started";

  const LandingPage({super.key}); // Example value

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Light turquoise (#A9F1DF)
              Color.fromARGB(255, 255, 255, 255), // Light pink (#FFBBBB)
            ],
            stops: [0.2, 0.8],
          ),
        ),
        padding: EdgeInsets.only(top: 120),
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              height: height * 0.30,
              width: width * 0.50,
            ),
            Text(
              wlcm,
              style: GoogleFonts.robotoMono(
                wordSpacing: 5,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              nxt,
              style: GoogleFonts.robotoMono(
                  wordSpacing: 5, fontSize: 26, color: Colors.black),
            ),
            SizedBox(height: 75), // Space between text and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white, // Set background color
                    side: BorderSide(color: Colors.black, width: 2), // Border
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  child: Text(
                    signup,
                    style: GoogleFonts.robotoMono(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(width: 50), // Space between the two buttons
                ElevatedButton(
                  onPressed: (
                  ) {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white, // Set background color
                    side: BorderSide(color: Colors.black, width: 2), // Border
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  child: Text(
                    login,
                    style: GoogleFonts.robotoMono(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
