import 'package:easy_assistance_app/Todo_task/AcceptDenyPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:intl/intl.dart';
import '../firestore_service.dart';



class MeetingNotificationIcon extends StatefulWidget {
  @override
  _MeetingNotificationIconState createState() => _MeetingNotificationIconState();
}

class _MeetingNotificationIconState extends State<MeetingNotificationIcon> {
  final FirestoreService firestoreService = FirestoreService();
  int meetingCount = 0;
  String? upcomingMeetingId;
  String userId= FirebaseAuth.instance.currentUser!.uid;

// Variable to store the meetingId of the first upcoming meeting


  @override
  void initState() {
    super.initState();
    _getMeetingCount();
  }

  // Fetch and count upcoming meetings
  void _getMeetingCount() {
    firestoreService.getMeetings(userId).listen((meetings) {
      final now = DateTime.now();

      // Filter for upcoming meetings
      final upcomingMeetings = meetings.where((meeting) {
        final meetingDate = _parseMeetingDate(meeting['date'], meeting['time']);
        return meetingDate.isAfter(now);  // Filter for meetings in the future
      }).toList();

      setState(() {
        meetingCount = upcomingMeetings.length;  // Set the meeting count
        if (upcomingMeetings.isNotEmpty) {
          upcomingMeetingId = upcomingMeetings.first['id'];  // Store the meetingId of the first upcoming meeting
        }
      });
    });
  }

  // Helper: Parse meeting date and time from Firestore
  DateTime _parseMeetingDate(String meetingDate, String meetingTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').parse('$meetingDate $meetingTime');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (upcomingMeetingId != null) {
          // Navigate to the AcceptDenyPage with the upcoming meetingId
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AcceptDenyPage(meetingId: upcomingMeetingId!)),
          );
        }
      },
      child: custom_badge.Badge(
        position: custom_badge.BadgePosition.topEnd(top: -13, end: 0),
        badgeContent: meetingCount > 0
            ? Text(
          '$meetingCount', // Show the meeting count
          style: TextStyle(color: Colors.white),
        )
            : null, // Show badge only if meetingCount > 0
        child: Icon(
          Icons.calendar_today, // Use a calendar icon for meetings
          size: 23,
          color: Colors.white,
        ),
      ),
    );
  }
}
