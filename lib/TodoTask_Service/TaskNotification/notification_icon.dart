import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:intl/intl.dart';
import '../firestore_service.dart';
import 'NotificationList.dart';

class NotificationIcon_Task extends StatefulWidget {
  const NotificationIcon_Task({Key? key}) : super(key: key);

  @override
  _NotificationIcon_TaskState createState() => _NotificationIcon_TaskState();
}

class _NotificationIcon_TaskState extends State<NotificationIcon_Task> {
  late FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
  }

  // Safely get current user ID
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // Helper to parse due date and time
  DateTime _parseDueDate(String dueDate, String dueTime) {
    try {
      return DateFormat('dd, MMM yyyy hh:mm a').parse('$dueDate $dueTime');
    } catch (e) {
      print('Date parsing error: $e');
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      // Show an empty badge if the user is not logged in
      return _buildBadge(0);
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestoreService.getTasks(userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildBadge(0); // Show "0" while loading
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildBadge(0); // Show "0" if no data
        }

        final tasks = snapshot.data!;
        final now = DateTime.now();

        // Filter tasks due within the next 3 days
        final upcomingTasks = tasks.where((task) {
          final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
          return dueDate.isAfter(now) && dueDate.difference(now).inDays <= 3;
        }).toList();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage_Task()),
            );
          },
          child: _buildBadge(upcomingTasks.length),
        );
      },
    );
  }

  // Helper method to build the badge with a notification icon
  Widget _buildBadge(int taskCount) {
    return custom_badge.Badge(
      position: custom_badge.BadgePosition.topEnd(top: -8, end: -8),
      badgeContent: taskCount > 0
          ? Text(
        '$taskCount',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      )
          : null, // Show no badge if count is 0
      child: const Icon(
        Icons.notifications,
        size: 28, // Icon size adjusted
        color: Colors.white,
      ),
    );
  }
}
