import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get the task stream from Firestore
  Stream<DocumentSnapshot> getTaskStream(String taskId) {
    return _firestore.collection('tasks').doc(taskId).snapshots();
  }

  // Method to update task status
  Future<void> updateTaskStatus(String taskId, String status) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({'status': status});
    } catch (e) {
      throw Exception('Error updating task status: $e');
    }
  }

  // Method to update status for all existing tasks programmatically
  Future<void> addStatusToAllTasks() async {
    try {
      // Fetch all tasks from Firestore
      QuerySnapshot taskSnapshot = await _firestore.collection('tasks').get();

      // Loop through all tasks and add the 'status' field
      for (var taskDoc in taskSnapshot.docs) {
        String taskId = taskDoc.id;
        await updateTaskStatus(taskId, 'incomplete'); // Default status 'incomplete'
      }
      print('Status field added to all tasks');
    } catch (e) {
      print('Error adding status to tasks: $e');
    }
  }

  // Stream to get task completion percentage
  Stream<double> getTaskCompletionPercentage() {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      final tasks = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      final totalTasks = tasks.length;
      if (totalTasks == 0) return 0.0;

      final completedTasks = tasks.where((task) => task['isCompleted'] == true).length;
      return completedTasks / totalTasks;
    });
  }

  // Add a new task to both 'tasks' and 'taskLists' collections
  Future<void> addTask(String task, String dueDate, String dueTime, String list) async {
    try {
      DocumentReference taskRef = await _firestore.collection('tasks').add({
        'task': task,
        'dueDate': dueDate,
        'dueTime': dueTime,
        'list': list,
        'created_at': FieldValue.serverTimestamp(),
      });

      QuerySnapshot taskListSnapshot = await _firestore.collection('taskLists')
          .where('name', isEqualTo: list)
          .get();

      if (taskListSnapshot.docs.isEmpty) {
        await _firestore.collection('taskLists').add({
          'name': list,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        DocumentSnapshot taskListDoc = taskListSnapshot.docs.first;
        String taskListId = taskListDoc.id;

        await _firestore.collection('taskLists').doc(taskListId).update({
          'taskCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Retrieve tasks from Firestore
  Stream<List<Map<String, dynamic>>> getTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  // Fetch all available lists from Firestore
  Future<List<String>> getTaskLists() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print("Error fetching task lists: $e");
      return [];
    }
  }

  // Add a new task list to Firestore
  Future<void> addNewTaskList(String listName) async {
    try {
      await _firestore.collection('taskLists').add({
        'name': listName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding new list: $e");
    }
  }

  // Save a meeting to Firestore
  Future<void> addMeeting(String title, String description, String date, String time, String location) async {
    try {
      await _firestore.collection('meetings').add({
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding meeting: $e');
    }
  }

  // Fetch meetings from Firestore
  Stream<List<Map<String, dynamic>>> getMeetings() {
    return _firestore.collection('meetings').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  // Delete a meeting
  Future<void> deleteMeeting(String meetingId) async {
    try {
      await _firestore.collection('meetings').doc(meetingId).delete();
    } catch (e) {
      print('Error deleting meeting: $e');
    }
  }

  // Edit a meeting
  Future<void> editMeeting(String meetingId, String title, String description, String date, String time, String location) async {
    try {
      await _firestore.collection('meetings').doc(meetingId).update({
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating meeting: $e');
    }
  }

  // Delete a task list
  Future<void> deleteTaskList(String listName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('taskLists')
          .where('name', isEqualTo: listName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await _firestore.collection('taskLists').doc(docId).delete();
      }
    } catch (e) {
      print("Error deleting task list: $e");
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  // Fetch completed tasks
  Stream<List<Map<String, dynamic>>> getCompletedTasks() {
    return _firestore.collection('tasks')
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  // Fetch tasks for a specific date
  Future<List<Map<String, dynamic>>> getTasksForDate(DateTime date) async {
    try {
      String formattedDate = DateFormat('dd, MMM yyyy').format(date);
      QuerySnapshot snapshot = await _firestore.collection('tasks')
          .where('dueDate', isEqualTo: formattedDate)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching tasks for date: $e');
      return [];
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String taskId, bool isFavorite) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'favorite': isFavorite,
      });
    } catch (e) {
      print("Error updating favorite: $e");
    }
  }

  // Fetch favorite tasks
  Stream<List<Map<String, dynamic>>> getFavoriteTasks() {
    return _firestore
        .collection('tasks')
        .where('favorite', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      print('Error updating task completion: $e');
    }
  }

  // Save a file locally
  Future<void> saveFileToLocalStorage(File file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${file.uri.pathSegments.last}';
      await file.copy(filePath);
    } catch (e) {
      print("Error saving file locally: $e");
    }
  }

  // Save a note to Firestore
  Future<void> saveNote(String noteContent, String noteTitle) async {
    try {
      await _firestore.collection('notes').add({
        'title': noteTitle,
        'content': noteContent,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving note: $e');
    }
  }

  // Retrieve all notes
  Stream<List<Map<String, dynamic>>> getNotes() {
    return _firestore.collection('notes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  // Update a note
  Future<void> updateNote(String noteId, String newContent, String newTitle) async {
    try {
      await _firestore.collection('notes').doc(noteId).update({
        'content': newContent,
        'title': newTitle,
      });
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  // Fetch task lists for dropdown
  Future<List<String>> fetchTaskListsForDropdown() async {
    QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }
}
