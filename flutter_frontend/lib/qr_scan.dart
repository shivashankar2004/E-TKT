import 'dart:convert'; // For decoding JSON data
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String ticketStatus = 'Scan a QR code to view the data';
  Map<String, dynamic>? qrData; // To hold the decoded JSON data

  // Function to process and display QR code JSON data
  void handleScannedQRData(String rawQrData) {
    try {
      // Decode the JSON string
      final decodedJson = jsonDecode(rawQrData);
      
      setState(() {
        qrData = decodedJson; // Store the decoded JSON data
        ticketStatus = 'QR code scanned successfully!'; // Update the status message
      });
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
