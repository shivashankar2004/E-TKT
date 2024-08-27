import 'package:flutter/material.dart';
import 'package:flutter_frontend/dummy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingPage extends StatefulWidget {
  final String name;
  final String? loc1;
  final String? loc2;

  const BookingPage({Key? key, required this.name, required this.loc1, required this.loc2} ):super(key: key);

  _MyBookingPage createState() => _MyBookingPage();
}

class _MyBookingPage extends State<BookingPage> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _bookNow() {
    // Functionality for booking goes here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking confirmed for ${widget.name}!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Booking Page',
          style: GoogleFonts.roboto(fontSize: 24, fontStyle: FontStyle.normal),
        ),
        elevation: 15.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            icon: Icon(
              Icons.navigate_before_rounded,
              size: 35,
              color: Color.fromARGB(255, 95, 33, 230),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.name} is travelling from ${widget.loc1} to ${widget.loc2}',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Add some spacing between text and button
            ElevatedButton(
              onPressed: _bookNow,
              child: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 95, 33, 230), // Text color
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
