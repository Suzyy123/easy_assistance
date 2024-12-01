import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:easy_assistance_app/Todo_task/NotificationList.dart';  // Import NotificationPage

class NotificationIcon extends StatelessWidget {
  final int taskCount;

  // Constructor with required taskCount
  NotificationIcon({Key? key, required this.taskCount}) : super(key: key);  // Add super(key: key) for proper initialization

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the NotificationPage when the icon is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()), // Ensure the page is available
        );
      },
      child: custom_badge.Badge(
        position: custom_badge.BadgePosition.topEnd(top: 0, end: 3),
        badgeContent: taskCount > 0
            ? Text(
          '$taskCount', // Show the task count
          style: TextStyle(color: Colors.white),
        )
            : null, // Only show the badge if taskCount > 0
        child: Icon(
          Icons.notifications,
          size: 50, // Adjust the icon size
          color: Colors.blue, // Change icon color
        ),
      ),
    );
  }
}
