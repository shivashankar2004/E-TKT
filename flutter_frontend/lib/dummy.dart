// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/locationdata.dart';
import 'package:flutter_frontend/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: duplicate_import
import 'locationdata.dart';

class MyHomePage extends StatefulWidget {
  final token;
  const MyHomePage({@required this.token, Key? key}) : super(key: key);
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
  void initState() {
    super.initState();
    initSharedprefs();
    Map<String, dynamic> jsondecodetoken = JwtDecoder.decode(widget.token);
    name = jsondecodetoken['name'];
  }

  void initSharedprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show an error
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, show an error
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Home Page',
            style:
                GoogleFonts.roboto(fontSize: 24, fontStyle: FontStyle.normal),
          ),
          elevation: 15.0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(
                  Icons.navigate_before_rounded,
                  size: 35,
                  color: Color.fromARGB(255, 95, 33, 230),
                ))
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello ',
                        style: GoogleFonts.roboto(
                            fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      TextSpan(
                          text: '$name!',
                          style: GoogleFonts.robotoMono(
                              fontSize: 24,
                              color: Color.fromARGB(255, 95, 33, 230))),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (!isClicked)
                  ElevatedButton(
                    onPressed: _handleLocationRequest,
                    child: Text('Click Me'),
                  ),
                SizedBox(height: 5),
                if (upcomingStops.isNotEmpty) ...[
                  Text('Select any of the Stops',
                      style: GoogleFonts.robotoFlex(
                          fontSize: 22, color: Colors.black)),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 7 * 56.0,
                    // Assuming each ListTile is 56.0 height
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: upcomingStops.length,
                      itemBuilder: (context, index) {
                        String stopName = upcomingStops[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: selectedStop == stopName
                                ? Color.fromARGB(0, 102, 218, 226)
                                    .withOpacity(0.5)
                                : null, // Rounded corners
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0), // Spacing around each item
                          child: ListTile(
                            title: Text(
                              '• $stopName',
                              style: GoogleFonts.roboto(
                                fontSize: 19,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () => _onStopTap(stopName),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30), // Space above the button
                  if (isClicked)
                    ElevatedButton(
                      onPressed: _clickBook,
                      child: Text('Proceed to payment'),
                    ),
                ],
              ],
            ),
          ),
        ));
  }

  void _handleLocationRequest() async {
    try {
      Position position = await _getCurrentLocation();
      // Use the latitude and longitude here

      List<String> fetchedstops = fetch(position.longitude);

      String currPosition = curr(position.longitude);

      setState(() {
        upcomingStops = fetchedstops;
        StopeOne = currPosition;
        isClicked = true;
      });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //       'Latitude: ${position.latitude}, Longitude: ${position.longitude}'),
      // ));
    } catch (e) {
      // ignore: use_build_context_synchronously
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You Journey is from $StopeOne to $selectedStop'),
      ),
    );
  }

  void _clickBook() async {
    if (isSelected) {
      _sendLoc(StopeOne, selectedStop);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select Your Destinaion"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendLoc(String? loc1, String? loc2) async {
  
   var res = await http.post(Uri.parse('http://192.168.37.176:5000/test'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'location1': loc1,
          'location2': loc2
        }));

    if (res.statusCode == 200) {
      var jsonres = jsonDecode(res.body);
      if (jsonres['status']) {
        var cost = jsonres['cost'];
        await prefs.setInt('cost', cost);
        await prefs.setString('location1', loc1!);
        await prefs.setString('location2', loc2!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cost fetched Successfully'),
          backgroundColor: Colors.green,
        ));
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
