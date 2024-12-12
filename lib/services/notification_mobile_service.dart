// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class NotificationService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   // Request notification permissions
//   Future<void> requestNotificationPermissions() async {
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//       // Call _getToken() after permission is granted
//       await _getToken();
//     } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
//       print('User denied permission');
//     } else {
//       print('User has not accepted or denied permission');
//     }
//   }
//
//   // Retrieve the FCM token
//   Future<void> _getToken() async {
//     try {
//       String? token = await _messaging.getToken();
//       if (token != null) {
//         print("FCM Token: $token");  // Print the token in the console
//       } else {
//         print('FCM token is null');
//       }
//     } catch (e) {
//       print('Error retrieving FCM token: $e');
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final String serverKey = "699807150469";  // From Firebase Console -> Project Settings -> Cloud Messaging
  final String fcmUrl = "https://fcm.googleapis.com/v1/projects/easyassistanceapplication/messages:send";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Request notification permissions
  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // Call _getToken() after permission is granted
      await _getToken();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('User denied permission');
    } else {
      print('User has not accepted or denied permission');
    }
  }

  // Retrieve the FCM token
  Future<void> _getToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        print("FCM Token: $token");  // Print the token in the console
      } else {
        print('FCM token is null');
      }
    } catch (e) {
      print('Error retrieving FCM token: $e');
    }
  }

  // Function to send a notification
  Future<void> sendNotification(String token, String title, String body) async {
    // Create the notification message
    final Map<String, dynamic> message = {
      "message": {
        "token": token,  // The device token you want to send the notification to
        "notification": {
          "title": title,  // Notification title
          "body": body     // Notification body/content
        }
      }
    };

    // Send the POST request
    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Authorization': 'Bearer $serverKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(message),
    );

    // Check the response
    if (response.statusCode == 200) {
      print('Notification sent successfully!');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  // Function to check if the task is 3 days away and send a notification
  Future<void> checkTaskDueDate(DateTime taskDueDate, String taskTitle, String token) async {
    DateTime currentDate = DateTime.now();
    Duration difference = taskDueDate.difference(currentDate);

    // If the task is 3 days away
    if (difference.inDays == 3) {
      // Send the notification
      await sendNotification(
          token,
          "Task Reminder",
          "Your task '$taskTitle' is due in 3 days!"
      );
    }
  }

  // Listen for tasks in Firestore and check if they are 3 days away
  void initializeNotifications(BuildContext context) {
    // Listen for tasks from Firestore
    _firestore.collection('tasks').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        var task = doc.data();
        DateTime taskDueDate = (task['dueDate'] as Timestamp).toDate();
        String taskTitle = task['task'];
        String? token = task['fcmToken'];  // Assuming fcmToken is stored with each task

        if (token != null) {
          // Check if the task is 3 days away
          checkTaskDueDate(taskDueDate, taskTitle, token);
        }
      }
    });
  }
}
