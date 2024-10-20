import 'package:flutter/material.dart';
import 'package:flutter_frontend/login.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:flutter_frontend/adm_login.dart';
import 'package:flutter_frontend/landingpage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg4.jpg'), // Background image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), // Dark overlay for readability
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Content aligned to the left
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 30.0), // Adjust padding for left alignment
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Break the "Welcome to Bus Ticketing Portal" into multiple lines
                  Text(
                    'Welcome\nto Bus\nTicketing Portal',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 38.0, // Large font size for heading
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        height: 1.3, // Adjust line height for better spacing
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0), // Spacing between heading and slogan

                  // Paragraph text, slightly adjusted for better readability
                  Text(
                    'Our platform offers a \nseamless experience for buying bus \ntickets, '
                    'whether \nyou\'re managing the system or \nbuying your ticket.',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5, // Adjust line height for better readability
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons positioned just below the center of the page
          Align(
            alignment: Alignment(0.0, 0.8), // Position buttons slightly lower
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Admin Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button color
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 10, // Add shadow for depth
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdminLoginPage())); // Admin route
                  },
                  child: Text(
                    'Admin',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 35.0), // Space between Admin and Customer buttons

                // Customer Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button color
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 10, // Add shadow for depth
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage())); // Customer route
                  },
                  child: Text(
                    'Passenger',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
