// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';  // Import the intl package
// import 'package:easy_assistance_app/Todo_task/firestore_service.dart';  // Assuming you have FirestoreService to get tasks
// import 'package:easy_assistance_app/Todo_task/notification_icon.dart'; // Import NotificationIcon
//
// class NotificationHome extends StatelessWidget {
//   final FirestoreService firestoreService = FirestoreService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Task Notifications'),
//         backgroundColor: Colors.blue[900],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: firestoreService.getTasks(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No tasks to display.'));
//           }
//
//           final tasks = snapshot.data!;
//           final now = DateTime.now();
//
//           // Filter tasks to get upcoming ones (within the next 3 days)
//           final upcomingTasks = tasks.where((task) {
//             final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
//             return dueDate.isAfter(now) && dueDate.difference(now).inDays <= 3;
//           }).toList();
//
//           return Column(
//             children: [
//               NotificationIcon(taskCount: upcomingTasks.length),  // Pass the task count here
//               // Other widgets or content you might want to display
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // Helper: Parse due date and time
//   DateTime _parseDueDate(String dueDate, String dueTime) {
//     return DateFormat('dd, MMM yyyy hh:mm a').parse('$dueDate $dueTime');
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import the intl package
import 'package:easy_assistance_app/Todo_task/firestore_service.dart';  // Assuming you have FirestoreService to get tasks
import 'package:easy_assistance_app/Todo_task/notification_icon.dart'; // Import NotificationIcon

class NotificationHome extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Notifications'),
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>( // Listening to Firestore data
        stream: firestoreService.getTasks(),  // Make sure getTasks() is working properly
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks to display.'));
          }

          final tasks = snapshot.data!;
          final now = DateTime.now();

          // Filter tasks to get upcoming ones (within the next 3 days)
          final upcomingTasks = tasks.where((task) {
            final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
            return dueDate.isAfter(now) && dueDate.difference(now).inDays <= 3;
          }).toList();

          // Return the UI with the notification icon and task count
          return Column(
            children: [
              NotificationIcon(taskCount: upcomingTasks.length),  // Pass the task count here
              // Other widgets or content you might want to display
            ],
          );
        },
      ),
    );
  }

  // Helper: Parse due date and time from the Firestore date and time fields
  DateTime _parseDueDate(String dueDate, String dueTime) {
    return DateFormat('dd, MMM yyyy hh:mm a').parse('$dueDate $dueTime');
  }
}
