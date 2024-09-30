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
  String ticketStatus = 'Scan a QR code to verify the ticket';

  Future<void> verifyTicket(String qrData) async {
    final url = Uri.parse('http://192.168.1.4:5555/check_ticket/$qrData');

    try {
      final response = await http.get(url);

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

      verifyTicket(qrData!);

      controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
