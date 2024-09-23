// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/bookingPage.dart';
import 'package:flutter_frontend/config.dart';
import 'package:flutter_frontend/home.dart';
import 'package:flutter_frontend/locationdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String name;
  List<String> upcomingStops = [];
  String? selectedStop;
  String? StopeOne;
  bool isClicked = false;
  bool isSelected = false;
  late SharedPreferences prefs;
  var token;

  @override
  void initState() {
    super.initState();
    initSharedprefs();
  }

  void initSharedprefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      Map<String, dynamic> jsondecodetoken = JwtDecoder.decode(token);
      name = jsondecodetoken['name'];
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF03045E), // Dark Blue
        title: Text(
          'Fetch Your Location',
          style: GoogleFonts.roboto(
            fontSize: 24,
            color: Colors.white, // Text color
            fontStyle: FontStyle.normal,
          ),
        ),
        elevation: 15.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserHomePage()),
              );
            },
            icon: Icon(
              Icons.navigate_before_rounded,
              size: 35,
              color: Color(0xFF90E0EF), // Pale Blue
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hello ',
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        color: Color(0xFF03045E), // Dark Blue
                      ),
                    ),
                    TextSpan(
                      text: '$name!',
                      style: GoogleFonts.robotoMono(
                        fontSize: 24,
                        color: Color(0xFF00B4D8), // Light Blue
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (!isClicked)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0077B6), // Medium Blue
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 10,
                  ),
                  onPressed: _handleLocationRequest,
                  child: Text(
                    'Click Me',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              SizedBox(height: 5),
              if (upcomingStops.isNotEmpty) ...[
                Text(
                  'Select any of the Stops',
                  style: GoogleFonts.robotoFlex(
                    fontSize: 22,
                    color: Color(0xFF03045E), // Dark Blue
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 7 * 56.0, // Assuming each ListTile is 56.0 height
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: upcomingStops.length,
                    itemBuilder: (context, index) {
                      String stopName = upcomingStops[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0077B6), // Medium Blue Border
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: selectedStop == stopName
                              ? Color(0xFF00B4D8).withOpacity(0.5) // Light Blue if selected
                              : Colors.white, // Default color
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        child: ListTile(
                          title: Text(
                            '• $stopName',
                            style: GoogleFonts.roboto(
                              fontSize: 19,
                              color: Color(0xFF03045E), // Dark Blue text
                            ),
                          ),
                          onTap: () => _onStopTap(stopName),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                if (isClicked)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0077B6), // Medium Blue
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 10,
                    ),
                    onPressed: _clickBook,
                    child: Text(
                      'Proceed to payment',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleLocationRequest() async {
    try {
      Position position = await _getCurrentLocation();

      List<String> fetchedstops = fetch(position.longitude);
      String currPosition = curr(position.longitude);

      setState(() {
        upcomingStops = fetchedstops;
        StopeOne = currPosition;
        isClicked = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  void _onStopTap(String stopName) {
    setState(() {
      selectedStop = stopName;
      isSelected = true;
    });
  }

  void _clickBook() async {
    if (isSelected) {
      _sendLoc(StopeOne, selectedStop);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select Your Destination"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendLoc(String? loc1, String? loc2) async {
    var res = await http.post(
      Uri.parse('${url}test'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'location1': loc1,
        'location2': loc2,
      }),
    );

    if (res.statusCode == 200) {
      var jsonres = jsonDecode(res.body);
      if (jsonres['status']) {
        var cost = jsonres['cost'];
        await prefs.setString('name', name);
        await prefs.setInt('cost', cost);
        await prefs.setString('location1', loc1!);
        await prefs.setString('location2', loc2!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BookingPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch the Cost: ${jsonres['messsage']}'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get the Cost: ${res.body}')),
      );
    }
  }
}
