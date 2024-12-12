import 'package:flutter/material.dart';
import 'package:easy_assistance_app/Todo_task/firestore_service.dart';
import 'package:intl/intl.dart';

class MeetingNotificationService {
  final FirestoreService _firestoreService = FirestoreService(); // Create Firestore instance

  // Initialize listener for due meetings
  void initializeNotifications(BuildContext context) {
    // Listen for meetings from Firestore
    _firestoreService.getMeetings().listen((meetings) {
      _checkForUpcomingMeetings(meetings, context);
    });
  }

  // Check for meetings that are due within the next 1 day or 1 hour
  void _checkForUpcomingMeetings(List<Map<String, dynamic>> meetings, BuildContext context) {
    DateTime now = DateTime.now();
    DateTime oneDayFromNow = now.add(Duration(days: 1)); // 1 day from now
    DateTime oneHourFromNow = now.add(Duration(hours: 1)); // 1 hour from now

    for (var meeting in meetings) {
      // Parse meeting date and time
      DateTime meetingDateTime = DateFormat('dd, MMM yyyy hh:mm a').parse(
        '${meeting['date']} ${meeting['time']}',
      );

      // Check if meeting is due within the next 1 day or 1 hour
      if (meetingDateTime.isBefore(oneDayFromNow) && meetingDateTime.isAfter(now)) {
        _showNotification(context, 'Meeting "${meeting['title']}" is due in less than 1 day!');
      } else if (meetingDateTime.isBefore(oneHourFromNow) && meetingDateTime.isAfter(now)) {
        _showNotification(context, 'Meeting "${meeting['title']}" is starting in less than 1 hour!');
      }
    }
  }

  // Show a simple notification (e.g., SnackBar)
  void _showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
