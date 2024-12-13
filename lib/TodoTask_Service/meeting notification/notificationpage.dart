import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPageID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Invitations'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('meetings')
            .where('status', isEqualTo: 'unread')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var meetings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              var meeting = meetings[index];
              return ListTile(
                title: Text('Meeting ID: ${meeting['meetingId']}'),
                subtitle: Text('Tap to respond'),
                onTap: () {
                  // Handle accept/deny or navigate to another page
                },
              );
            },
          );
        },
      ),
    );
  }
}
