import 'package:flutter/material.dart';
// import 'qr_scan.dart';

class TicketSuccessPage extends StatelessWidget {
  final Map<String, dynamic>
      ticketData; // Passed ticket data from the QR scanner page

  TicketSuccessPage(
      {required this.ticketData}); // Constructor to receive the ticket data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Verified'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the scanner page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Ticket Details:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: ticketData.length,
                itemBuilder: (context, index) {
                  String key = ticketData.keys.elementAt(index);
                  return ListTile(
                    title: Text(
                      key,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${ticketData[key]}'),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to scanner page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                ),
                child: Text('Back to Scanner'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
