import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date/time formatting
import 'package:fluttertoast/fluttertoast.dart'; // Optional: Toast notifications

class TicketSuccessPage extends StatelessWidget {
  final Map<String, dynamic> ticketData; // Passed ticket data from QR scanner

  TicketSuccessPage({required this.ticketData}); // Constructor

  bool isTicketValid(DateTime? issueDate) {
    if (issueDate == null) return false; // Invalid if time is null

    final currentTime = DateTime.now();
    final difference = currentTime.difference(issueDate).inMinutes;
    return difference <= 20; // Valid if within 20 minutes
  }

  @override
  Widget build(BuildContext context) {
    // Extract the issueDate safely with null check
    final issueDateStr = ticketData['issueDate'] as String?;
    DateTime? issueDate;

    try {
      if (issueDateStr != null) {
        issueDate = DateTime.parse(issueDateStr);
      }
    } catch (e) {
      issueDate = null;
    }

    // Check ticket validity
    final bool ticketValid = isTicketValid(issueDate);

    // Colors based on ticket validity
    final Color backgroundColor = Colors.white;
    final Color appBarColor = ticketValid ? Colors.green : Colors.red;
    final Color textColor = ticketValid ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ticketValid ? 'Ticket Verified' : 'Invalid Ticket',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Back to scanner
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Fluttertoast.showToast(
                msg: "Ticket Verification Info",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
          )
        ],
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: ticketValid
            ? _buildTicketDetails(textColor, context) // Show ticket details if valid
            : _buildInvalidTicketMessage(textColor, context), // Show invalid message
      ),
    );
  }

  // Widget to display valid ticket details
  Widget _buildTicketDetails(Color textColor, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ticket Details:',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: ticketData.length,
            itemBuilder: (context, index) {
              String key = ticketData.keys.elementAt(index);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${ticketData[key]}'),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Back to scanner
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Back to Scanner'),
          ),
        ),
      ],
    );
  }

  // Widget to display invalid ticket message
  Widget _buildInvalidTicketMessage(Color textColor, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: textColor,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            'Invalid Ticket!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This ticket is no longer valid or improperly scanned.',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Fluttertoast.showToast(
                msg: "Please scan a new ticket.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
              Navigator.pop(context); // Back to scanner
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Scan Next'),
          ),
        ],
      ),
    );
  }
}
