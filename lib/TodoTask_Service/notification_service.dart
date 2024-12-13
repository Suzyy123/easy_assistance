import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'package:intl/intl.dart';

class NotificationService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();

  String userId= FirebaseAuth.instance.currentUser!.uid;

  // // Initialize listener for due tasks
  // void initializeNotifications(BuildContext context) {
  //   _firestoreService.getTasks().listen((tasks) {
  //     _checkForDueTasks(tasks, context);
  //   });
  // }
  // Initialize listener for due tasks
  void initializeNotifications(BuildContext context) {
    // Listen for tasks from Firestore
    _firestoreService.getTasks(userId).listen((tasks) {
      _checkForDueTasks(tasks, context);
    });
  }

  // // Check for tasks that are due
  // void _checkForDueTasks(List<Map<String, dynamic>> tasks, BuildContext context) {
  //   DateTime now = DateTime.now();
  // Check for tasks that are due (or will be due in the next 3 days)
  void _checkForDueTasks(List<Map<String, dynamic>> tasks, BuildContext context) {
    DateTime now = DateTime.now();
    DateTime threeDaysFromNow = now.add(Duration(days: 3));  // 3 days from now


    for (var task in tasks) {
      DateTime taskDueDate = DateFormat('dd, MMM yyyy hh:mm a').parse(
        '${task['dueDate']} ${task['dueTime']}',
      );

      //     if (taskDueDate.isBefore(now)) {
      //       _showNotification(context, 'Task "${task['task']}" is due!');
      //     }
      //   }
      // }
      // Check if the task is due now or within the next 3 days
      if (taskDueDate.isBefore(threeDaysFromNow) && taskDueDate.isAfter(now)) {
        _showNotification(context, 'Task "${task['task']}" is due soon!');
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
