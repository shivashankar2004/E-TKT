import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_frontend/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart'; // Assuming this holds the URL configurations

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late SharedPreferences prefs;
  late String name; // Default name
  var qrData; // To hold encrypted name for QR code
  bool hasTicket = true;
  var token; // Flag to check if ticket is available

  @override
  void initState() {
    super.initState();
    initSp(); // Initialize SharedPreferences
  }

  void initSp() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      Map<String, dynamic> jsondecodetoken = JwtDecoder.decode(token);
      name = jsondecodetoken['name'];
    });
  }

  void logout() async {
    await prefs.clear();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage())); // Replace with your login route
  }

  Future<void> generateQR() async {
    var res = await http.post(Uri.parse('${url}ticket'),
        headers: <String, String>{
          'Content-type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{'name': name}));
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      if (json['status']) {
        setState(() {
          qrData = jsonEncode(json['ticket']);
          hasTicket = true; // Ticket is available
        });
      }
    } else if (res.statusCode == 204) {
      setState(() {
        qrData = null;
        hasTicket = false; // No ticket available
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle, // Icon for the profile page
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              "Profile",
              style: GoogleFonts.bebasNeue(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF03045e), // Dark Navy background
        elevation: 10.0,
        shadowColor: Color(0xFF0077b6), // Deep Blue Shadow
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_before_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            }, // Logout action
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color.fromARGB(255, 255, 255, 255), // Pale Blue Background
              Color.fromARGB(255, 255, 255, 255), // Soft Blue Gradient
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Name Display
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  "UserName: $name",
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045e), // Dark Navy Text
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            // Conditional "View Ticket" Button
            if (hasTicket)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF0077b6), // Deep Blue Button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5.0,
                ),
                onPressed: generateQR,
                child: Text(
                  "View Ticket",
                  style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    color: Color(0xFFcaf0f8), // Pale Blue Text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // QR Code or No Ticket Message
            if (qrData != null)
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "QR Ticket",
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        color: Color(0xFF03045e), // Dark Navy Text
                      ),
                    ),
                    SizedBox(height: 20),
                    QrImageView(
                      data: qrData!,
                      version: QrVersions.auto,
                      size: 200.0, // QR Code Size
                    ),
                  ],
                ),
              ),

            if (!hasTicket)
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Text(
                      "No Tickets Available",
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03045e), // Dark Navy
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor:
                            Color(0xFF00b4d8), // Bright Blue Button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5.0,
                      ),
                      onPressed: () {
                        // Action for booking tickets
                      },
                      child: Text(
                        "Book Ticket Now",
                        style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          color: Colors.white, // White Text Color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
