import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/config.dart';
import 'package:flutter_frontend/currLoc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  _MyBookingPage createState() => _MyBookingPage();
}

class _MyBookingPage extends State<BookingPage> {
  late SharedPreferences prefs;
  late String name;
  late String? loc1;
  late String? loc2;
  late int cost;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      loc1 = prefs.getString('location1')!;
      loc2 = prefs.getString('location2')!;
      cost = prefs.getInt('cost')!;
    });
  }

  Future<void> _bookNow() async {
    var res = await http.put(Uri.parse('${url}book'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'location1': loc1,
          'location2': loc2,
          'cost':cost
        }));

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking confirmed for ${name}!')),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error : ${res.statusCode}')),
      );
    }
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage()));
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
              'The Cost for is travelling from ${loc1} to ${loc2} is ${cost}',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookNow,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 95, 33, 230), // Text color
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
