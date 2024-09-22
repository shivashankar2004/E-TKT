import 'package:flutter/material.dart';
import 'package:flutter_frontend/currLoc.dart';
import 'package:flutter_frontend/login.dart';
import 'package:flutter_frontend/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UserHomePage> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  // Initialize SharedPreferences
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Logout Function
  void logout() async {
    await prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  // Method to show a logout confirmation dialog
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Logout Confirmation'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  logout(); // Call logout if confirmed
                  Navigator.of(context).pop(true);
                },
                child: Text('Logout'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button press
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_activity, // Ticket icon
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'Ticket Hub',
                style: GoogleFonts.bebasNeue(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF03045e), // Dark Navy
          elevation: 15.0,
          shadowColor: Color(0xFF0077b6), // Deep Blue Shadow
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: logout, // Call the logout function
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          decoration: BoxDecoration(
            color: Colors.white, // White Background
            gradient: LinearGradient(
              colors: const [
                Color.fromARGB(255, 255, 255, 255), // Pale Blue
                Color.fromARGB(255, 247, 247, 247), // Soft Blue
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Message
              Text(
                'Welcome to Ticket Hub!',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045e), // Dark Navy Text Color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0),

              // Buy Ticket Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor:
                      Color(0xFF0077b6), // Deep Blue Button Background
                  elevation: 5.0,
                ),
                onPressed: () {
                  // Navigate to Buy Ticket Page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage())); // Replace with actual page
                },
                child: Text(
                  'Buy Ticket',
                  style: GoogleFonts.robotoMono(
                    fontSize: 20.0,
                    color: Colors.white, // White Text Color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 20.0), // Space between buttons

              // View Profile Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor:
                      Color(0xFF00b4d8), // Bright Blue Button Background
                  elevation: 5.0,
                ),
                onPressed: () {
                  // Navigate to Profile Page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                child: Text(
                  'View Profile',
                  style: GoogleFonts.robotoMono(
                    fontSize: 20.0,
                    color: Colors.white, // White Text Color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Spacer(), // Pushes the logo to the bottom
            ],
          ),
        ),
      ),
    );
  }
}
