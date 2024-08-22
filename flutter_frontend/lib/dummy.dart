import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/locationdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
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
  void initState() {
    super.initState();

    Map<String, dynamic> jsondecodetoken = JwtDecoder.decode(widget.token);
    name = jsondecodetoken['name'];
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
    appBar: AppBar(title: Text('Home Page'), bottomOpacity: 2.0),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hello $name!!',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          if (!isClicked)
            ElevatedButton(
              onPressed: _handleLocationRequest,
              child: Text('Click Me'),
            ),
          SizedBox(height: 20),
          if (upcomingStops.isNotEmpty) ...[
            SizedBox(height: 20),
            Text(
              'Upcoming Stops',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: upcomingStops.length,
                      itemBuilder: (context, index) {
                        String stopName = upcomingStops[index];
                        return ListTile(
                          title: Text(stopName),
                          tileColor: selectedStop == stopName
                              ? Colors.blue.withOpacity(0.3)
                              : null,
                          onTap: () => _onStopTap(stopName),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 2), // Space above the button
                  if (selectedStop != null)
                    ElevatedButton(
                      onPressed: () {
                        // Implement booking functionality here
                      },
                      child: Text('Book'),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
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

      _sendLoc(position.latitude, position.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  void _onStopTap(String stopName) {
    setState(() {
      selectedStop = stopName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You Journey is from $StopeOne to $selectedStop'),
      ),
    );
  }

  Future<http.Response> _sendLoc(double lat, double long) async {
    return await http.post(Uri.parse('http://192.168.62.176:3000/test'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{'name': name, 'longitude': long}));
  }
}
