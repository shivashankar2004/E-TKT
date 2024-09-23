import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String ticketStatus = 'Scan a QR code to verify the ticket';

  /// Function to extract the ticket from QR data
  String? extractTicket(String? qrData) {
    if (qrData == null || qrData.isEmpty) {
      print('QR data is null or empty');
      return null; // Return null if data is invalid
    }

    try {
      // Assuming the QR data is a JSON string that contains a 'ticket' field
      var decodedData = jsonDecode(qrData);
      print('Decoded QR data: $decodedData');

      if (decodedData is Map && decodedData.containsKey('ticket')) {
        return decodedData['ticket']; // Return the ticket data
      } else {
        print('Ticket not found in QR data');
        return null;
      }
    } catch (e) {
      print('Error decoding QR data: $e');
      return null;
    }
  }

  /// Verify the ticket using the extracted ticket data
  Future<void> verifyTicket(String ticket) async {
    final url = Uri.parse('http://192.168.203.159:5555/check_ticket/$ticket');

    try {
      final response = await http.get(url);
      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          ticketStatus = 'Ticket found: ${response.body}';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          ticketStatus = 'Ticket not found';
        });
      } else {
        setState(() {
          ticketStatus = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        ticketStatus = 'Error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Ticket Scanner'),
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
              child: Text(ticketStatus),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final qrData = scanData.code;

      // Debugging: Print the raw QR data to the console
      print('Scanned QR data: $qrData');

      // Extract ticket from the scanned QR data
      final ticket = extractTicket(qrData);

      if (ticket != null) {
        print('Extracted ticket: $ticket');
        // Verify ticket using the extracted ticket data
        verifyTicket(ticket);
        controller.pauseCamera(); // Pause the camera after scanning
      } else {
        setState(() {
          ticketStatus = 'Invalid QR code data';
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
