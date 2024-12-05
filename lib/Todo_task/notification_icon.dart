import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:easy_assistance_app/Todo_task/NotificationList.dart';  // Import NotificationPage

class NotificationIcon extends StatefulWidget {
  final int taskCount;


  // Constructor with required taskCount
  NotificationIcon({Key? key, required this.taskCount}) : super(key: key);

  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  late int _taskCount;
  late int _meetingCount; // Track the meeting count

  @override
  void initState() {
    super.initState();
    _taskCount = widget.taskCount; // Initialize the taskCount
  }

  // Function to reset the taskCount to 0 when the icon is clicked
  void _resetTaskCount() {
    setState(() {
      _taskCount = 0; // Reset the count when the notification is clicked
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _resetTaskCount();  // Reset the taskCount when the icon is clicked
        // Navigate to the NotificationPage when the icon is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()), // Ensure the page is available
        );
      },
      child: custom_badge.Badge(
        position: custom_badge.BadgePosition.topEnd(top: 0, end: 1),
        badgeContent: _taskCount > 0
            ? Text(
          '$_taskCount', // Show the task count
          style: TextStyle(color: Colors.white),
        )
            : null, // Only show the badge if taskCount > 0
        child: Icon(
          Icons.notifications,
          size: 35, // Adjust the icon size
          color: Colors.white, // Change icon color
        ),
      ),
    );
  }
}

