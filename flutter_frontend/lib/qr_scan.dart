import 'dart:convert'; // For decoding JSON data
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'ticket_success_page.dart'; 

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isCameraOn = true; // For toggling camera on/off
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

      // Navigate to success page after decoding and verifying the ticket
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketSuccessPage(ticketData: decodedJson), // Pass the ticket data
        ),
      ).then((_) {
        // When returning from the success page, reset the scanner
        _resetScanner();
      });
    } catch (e) {
      setState(() {
        ticketStatus = 'Invalid QR code or JSON data!'; // Error if decoding fails
      });
    }
  }

  // Function to reset the scanner for the next ticket scan
  void _resetScanner() {
    setState(() {
      ticketStatus = 'Scan a QR code to view the data'; // Reset the status
      qrData = null; // Clear the previous data
    });
    controller?.resumeCamera(); // Resume the camera for the next scan
  }

  // Function to toggle the camera on and off
  void _toggleCamera() {
    if (isCameraOn) {
      controller?.pauseCamera();
    } else {
      controller?.resumeCamera();
    }
    setState(() {
      isCameraOn = !isCameraOn; // Toggle camera state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR JSON Scanner'),
        actions: [
          IconButton(
            icon: Icon(isCameraOn ? Icons.camera_alt : Icons.videocam_off), // Using alternative icon
            onPressed: _toggleCamera, // Button to toggle the camera
          )
        ],
      ),
      body: Stack(
        children: [
          // Camera View Container (shrunken to fit inside the green border)
          Positioned(
            left: 30,
            right: 30,
            top: 100,
            bottom: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          // Green border (scan area) around the shrunken camera view
          Positioned(
            left: 30,
            right: 30,
            top: 100,
            bottom: 250,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4), // Green border
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
            ),
          ),
          // Semi-transparent overlay outside the scan area
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                  ),
                ),
              ],
            ),
          ),
          // Instruction Text and Ticket Status
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Align the QR code within the frame to scan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  ticketStatus,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
            ),
          ),
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
