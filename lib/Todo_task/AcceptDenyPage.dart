import 'package:easy_assistance_app/Todo_task/premium.dart';
import 'package:flutter/material.dart';

class AcceptDenyPage extends StatelessWidget {
  final String meetingId;

  AcceptDenyPage({required this.meetingId});

  @override
  Widget build(BuildContext context) {
    // Log the meetingId received
    print('Navigated to AcceptDenyPage with meetingId: $meetingId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Invitation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.white), // Make back arrow white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Meeting ID: $meetingId',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Highlight meeting ID
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Do you accept the meeting request?',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to another page on "Accept"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PremiumPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Accept',
                          style: TextStyle(fontSize: 16, color: Colors.white), // Set text color to white
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to another page on "Deny"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PremiumPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Deny',
                          style: TextStyle(fontSize: 16, color: Colors.white), // Set text color to white
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define the AcceptedPage
class AcceptedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'You have accepted the meeting request!',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}

// Define the DeniedPage
class DeniedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denied'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          'You have denied the meeting request.',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
