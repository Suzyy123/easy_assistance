import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notificationID_service.dart';
import 'notificationpage.dart'; // Assuming this is your file

class MeetingIconWithBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meetingService = Provider.of<meetingService1>(context);

    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications), // Meeting icon
          onPressed: () {
            // When the icon is pressed, reset the unread count and navigate to NotificationPage
            meetingService.resetUnreadMeetingCount();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPageID(), // Assuming this is your notification page
              ),
            );
          },
        ),
        if (meetingService.unreadMeetingCount > 0) // Show badge only if there are unread meetings
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                '${meetingService.unreadMeetingCount}', // Show the unread count
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
