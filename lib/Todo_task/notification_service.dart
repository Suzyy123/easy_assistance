import 'package:flutter/material.dart';
import 'package:easy_assistance_app/Todo_task/firestore_service.dart';
import 'package:intl/intl.dart';

class NotificationService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService(); // Create instance

  // Initialize listener for due tasks
  void initializeNotifications(BuildContext context) {
    _firestoreService.getTasks().listen((tasks) {
      _checkForDueTasks(tasks, context);
    });
  }

  // Check for tasks that are due
  void _checkForDueTasks(List<Map<String, dynamic>> tasks, BuildContext context) {
    DateTime now = DateTime.now();

    for (var task in tasks) {
      DateTime taskDueDate = DateFormat('dd, MMM yyyy hh:mm a').parse(
        '${task['dueDate']} ${task['dueTime']}',
      );

      if (taskDueDate.isBefore(now)) {
        _showNotification(context, 'Task "${task['task']}" is due!');
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
