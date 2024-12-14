// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as custom_badge;
// import 'package:easy_assistance_app/Todo_task/NotificationList.dart';  // Import NotificationPage
//
// class NotificationIcon extends StatefulWidget {
//   final int taskCount;
//
//
//   // Constructor with required taskCount
//   NotificationIcon({Key? key, required this.taskCount}) : super(key: key);
//
//   @override
//   _NotificationIconState createState() => _NotificationIconState();
// }
//
// class _NotificationIconState extends State<NotificationIcon> {
//   late int _taskCount;
//   //late int _meetingCount; // Track the meeting count
//
//   @override
//   void initState() {
//     super.initState();
//     _taskCount = widget.taskCount; // Initialize the taskCount
//   }
//
//   // Function to reset the taskCount to 0 when the icon is clicked
//   void _resetTaskCount() {
//     setState(() {
//       _taskCount = 0; // Reset the count when the notification is clicked
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _resetTaskCount();  // Reset the taskCount when the icon is clicked
//         // Navigate to the NotificationPage when the icon is tapped
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => NotificationPage()), // Ensure the page is available
//         );
//       },
//       child: custom_badge.Badge(
//         position: custom_badge.BadgePosition.topEnd(top: 0, end: 1),
//         badgeContent: _taskCount > 0
//             ? Text(
//           '$_taskCount', // Show the task count
//           style: TextStyle(color: Colors.white),
//         )
//             : null, // Only show the badge if taskCount > 0
//         child: Icon(
//           Icons.notifications,
//           size: 35, // Adjust the icon size
//           color: Colors.white, // Change icon color
//         ),
//       ),
//     );
//   }
// }
//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:intl/intl.dart';
import '../firestore_service.dart';
import 'NotificationList.dart';

class NotificationIcon_Task extends StatefulWidget {
  const NotificationIcon_Task({Key? key}) : super(key: key);

  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon_Task> {
  late FirestoreService firestoreService;
  String userId= FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(); // Initialize the Firestore service
  }

  // Helper: Parse due date and time from Firestore date and time fields
  DateTime _parseDueDate(String dueDate, String dueTime) {
    return DateFormat('dd, MMM yyyy hh:mm a').parse('$dueDate $dueTime');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestoreService.getTasks(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return custom_badge.Badge(
            badgeContent: const Text(
              '0',
              style: TextStyle(color: Colors.white),
            ),
            child: const Icon(
              Icons.notifications,
              size: 35,
              color: Colors.white,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return custom_badge.Badge(
            badgeContent: const Text(
              '0',
              style: TextStyle(color: Colors.white),
            ),
            child: const Icon(
              Icons.notifications,
              size: 35,
              color: Colors.white,
            ),
          );
        }

        final tasks = snapshot.data!;
        final now = DateTime.now();

        // Filter tasks to get upcoming ones (within the next 3 days)
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
          child: custom_badge.Badge(
            position: custom_badge.BadgePosition.topEnd(top: -13, end: -12),
            badgeContent: upcomingTasks.isNotEmpty
                ? Text(
              '${upcomingTasks.length}',
              style: const TextStyle(color: Colors.white),
            )
                : null, // Only show the badge if task count > 0
            child: const Icon(
              Icons.notifications,
              size: 26,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
