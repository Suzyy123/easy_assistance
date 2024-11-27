// // firestore_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Method to add a new task to the 'tasks' collection
//   Future<void> addTask(String task, String dueDate, String dueTime, String list) async {
//     try {
//       await _firestore.collection('tasks').add({
//         'task': task,
//         'dueDate': dueDate,
//         'dueTime': dueTime,
//         'list': list,
//         'created_at': FieldValue.serverTimestamp(),
//       });
//       print('Task added successfully');
//     } catch (e) {
//       print('Error adding task: $e');
//     }
//   }
// }
