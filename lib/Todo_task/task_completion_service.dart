// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TaskCompletionService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Method to update task completion status
//   Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
//     try {
//       // Update the 'isCompleted' field of the task
//       await _firestore.collection('tasks').doc(taskId).update({
//         'isCompleted': isCompleted,
//       });
//       print('Task completion status updated successfully');
//     } catch (e) {
//       print('Error updating task completion: $e');
//     }
//   }
//
//   // // Method to delete a task
//   // Future<void> deleteTask(String taskId) async {
//   //   try {
//   //     // Delete the task by its ID
//   //     await _firestore.collection('tasks').doc(taskId).delete();
//   //     print('Task deleted successfully');
//   //   } catch (e) {
//   //     print('Error deleting task: $e');
//   //   }
//   //}
// }
