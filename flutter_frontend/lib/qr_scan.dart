import 'dart:convert'; // For decoding JSON data
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
// Ensure your config file is correct

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String ticketStatus = 'Scan a QR code to view the data';
  Map<String, dynamic>? qrData; // To hold the decoded JSON data
  Duration allowedInterval = Duration(minutes: 20); // 20-minute window

  // Function to validate if the ticket timestamp is within the allowed interval
  bool isTicketValid(String issueDate) {
    try {
      DateTime ticketTime = DateTime.parse(issueDate); // Parse the issueDate from the QR code
      DateTime currentTime = DateTime.now();

      Duration difference = currentTime.difference(ticketTime).abs(); // Get the absolute difference

      // Check if the difference is within the allowed 20-minute window
      return difference <= allowedInterval;
    } catch (e) {
      return false; // Return false if there's an error in parsing the timestamp
    }
  }

  // Function to process and display QR code JSON data
  void handleScannedQRData(String rawQrData) {
    try {
      // Decode the JSON string
      final decodedJson = jsonDecode(rawQrData);

      // Check if the JSON has an 'issueDate' and validate it
      if (decodedJson.containsKey('issueDate') && isTicketValid(decodedJson['issueDate'])) {
        setState(() {
          qrData = decodedJson; // Store the decoded JSON data
          ticketStatus = 'Valid ticket. QR code scanned successfully!'; // Update the status message
        });
      } else {
        setState(() {
          ticketStatus = 'Invalid or expired ticket!'; // Error if timestamp is invalid or expired
        });
      }
    } catch (e) {
      setState(() {
        ticketStatus = 'Invalid QR code or JSON data!'; // Error if decoding fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR JSON Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: qrData != null
                  ? ListView(
                      padding: EdgeInsets.all(10),
                      children: qrData!.entries.map((entry) {
                        return ListTile(
                          title: Text('${entry.key}'),
                          subtitle: Text('${entry.value}'),
                        );
                      }).toList(),
                    )
                  : Text(ticketStatus), // Show the status or error
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final rawQrData = scanData.code;

      if (rawQrData != null) {
        handleScannedQRData(rawQrData); // Handle the scanned QR data as JSON
        controller.pauseCamera(); // Pause the camera after scanning to prevent multiple scans
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
