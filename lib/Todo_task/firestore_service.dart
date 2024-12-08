import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a new task to both 'tasks' and 'taskLists' collections
  Future<void> addTask(String task, String dueDate, String dueTime, String list) async {
    try {
      // Step 1: Add task to 'tasks' collection
      DocumentReference taskRef = await _firestore.collection('tasks').add({
        'task': task,
        'dueDate': dueDate,
        'dueTime': dueTime,
        'list': list,
        'created_at': FieldValue.serverTimestamp(),
      });

      print('Task added successfully');

      // Step 2: Check if task list exists in 'taskLists' collection
      QuerySnapshot taskListSnapshot = await _firestore.collection('taskLists')
          .where('name', isEqualTo: list)
          .get();

      if (taskListSnapshot.docs.isEmpty) {
        // If the task list doesn't exist, create a new one
        await _firestore.collection('taskLists').add({
          'name': list,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('New task list created successfully');
      } else {
        // If the task list exists, you may want to update the task list with additional info
        // For example, you could add a task count or some other field. Here's an example:
        DocumentSnapshot taskListDoc = taskListSnapshot.docs.first;
        String taskListId = taskListDoc.id;

        // Optionally, update task list with task count or other metadata
        await _firestore.collection('taskLists').doc(taskListId).update({
          'taskCount': FieldValue.increment(1),  // Increment task count
        });
        print('Task list updated with new task count');
      }

    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Method to retrieve tasks from Firestore
  Stream<List<Map<String, dynamic>>> getTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Add document ID for reference
          return data;
        }).toList());
  }

  // Fetch all available task lists from Firestore
  Future<List<String>> getTaskLists() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print("Error fetching task lists: $e");
      return [];
    }
  }

  //Add a new task list to Firestore
  Future<void> addNewTaskList(String listName) async {
    try {
      await _firestore.collection('taskLists').add({
        'name': listName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("New task list added successfully.");
    } catch (e) {
      print("Error adding new list: $e");
    }
  }

// New method with a different name to avoid conflict
  Future<List<String>> fetchTaskListsForDropdown() async {
    QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
    List<String> taskLists = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    return taskLists;
  }
}


  // // Simple method to delete a task list by its name
  // Future<void> deleteTaskList(String listName) async {
  //   try {
  //     // Find the task list by name
  //     QuerySnapshot querySnapshot = await _firestore.collection('taskLists')
  //         .where('name', isEqualTo: listName)
  //         .get();
  //
  //     // If a task list is found, delete it
  //     if (querySnapshot.docs.isNotEmpty) {
  //       String docId = querySnapshot.docs.first.id;
  //       await _firestore.collection('taskLists').doc(docId).delete();
  //       print("Task list '$listName' deleted successfully.");
  //     } else {
  //       print("No task list found with the name '$listName'.");
  //     }
  //   } catch (e) {
  //     print("Error deleting task list: $e");
  //   }
  // }






