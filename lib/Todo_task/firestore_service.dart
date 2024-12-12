import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

      // print('Task added successfully');


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

  // Method to retrieve tasks from Firestore/ TasksListPAge
  Stream<List<Map<String, dynamic>>> getTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Add document ID for reference
          return data;
        }).toList());
  }

 // Fetch all available  lists from Firestore LISTS
  Future<List<String>> getTaskLists() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print("Error fetching task lists: $e");
      return [];
    }
  }




  //Add a new  tasklist to Firestore/
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

  //method to save meeting
  Future<void> addMeeting(String title, String description, String date, String time, String location) async {
    try {

      DocumentReference meetRef = await _firestore.collection('meetings').add({
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'created_at': FieldValue.serverTimestamp(),
      });
      print('Meeting added successfully');
    } catch (e) {
      print('Error adding meeting: $e');
    }
  }

// Stream method to fetch meetings from Firestore
  Stream<List<Map<String, dynamic>>> getMeetings() {
    return _firestore.collection('meetings').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add document ID for reference
          return data;
        }).toList());
  }

// Method to delete a meeting from Firestore
  Future<void> deleteMeeting(String meetingId) async {
    try {
      // Delete the meeting by its ID
      await _firestore.collection('meetings').doc(meetingId).delete();
      print('Meeting deleted successfully');
    } catch (e) {
      print('Error deleting meeting: $e');
    }
  }

  // Method to edit a meeting in Firestore
  Future<void> editMeeting(String meetingId, String title, String description, String date, String time, String location) async {
    try {
      // Update the meeting with the new values
      await _firestore.collection('meetings').doc(meetingId).update({
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'updated_at': FieldValue.serverTimestamp(),  // Optional: Track the last update time
      });
      print('Meeting updated successfully');
    } catch (e) {
      print('Error updating meeting: $e');
    }
  }

  // Method to delete a task list permanently from Firestore
  Future<void> deleteTaskList(String listName) async {
    try {
      // Find the task list by name
      QuerySnapshot querySnapshot = await _firestore.collection('taskLists')
          .where('name', isEqualTo: listName)
          .get();

      // If a task list is found, delete it
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await _firestore.collection('taskLists').doc(docId).delete();
        print("Task list '$listName' deleted successfully.");
      } else {
        print("No task list found with the name '$listName'.");
      }
    } catch (e) {
      print("Error deleting task list: $e");
    }
  }

  // Method to delete a task tasks
  Future<void> deleteTask(String taskId) async {
    try {
      // Delete the task by its ID
      await _firestore.collection('tasks').doc(taskId).delete();
      print('Task deleted successfully');
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  // Method to fetch completed tasks/Completed Tasks
  Stream<List<Map<String, dynamic>>> getCompletedTasks() {
    return _firestore.collection('tasks')
        .where('isCompleted', isEqualTo: true)  // Filter completed tasks
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;  // Add document ID for reference
          return data;
        }).toList());
  }

  Future<List<Map<String, dynamic>>> getTasksForDate(DateTime date) async {
    try {
      // Format the date to match the format stored in Firestore
      String formattedDate = DateFormat('dd, MMM yyyy').format(date);

      // Query tasks for the selected date, regardless of completion status
      QuerySnapshot snapshot = await _firestore.collection('tasks')
          .where('dueDate', isEqualTo: formattedDate)
          .get();

      // Map the snapshot data into a list of tasks
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for reference
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching tasks for date: $e');
      return [];
    }
  }

// Method to toggle/make favorite status
  Future<void> toggleFavorite(String taskId, bool isFavorite) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'favorite': isFavorite,
      });
    } catch (e) {
      print("Error updating favorite: $e");
    }
  }

  // Method to fetch tasks that are marked as favorite
  Stream<List<Map<String, dynamic>>> getFavoriteTasks() {
    return _firestore
        .collection('tasks')
        .where('favorite', isEqualTo: true) // Filter tasks where favorite is true
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add document ID for reference
          return data;
        }).toList());
  }

  // Method to update task completion status
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      // Update the 'isCompleted' field of the task
      await _firestore.collection('tasks').doc(taskId).update({
        'isCompleted': isCompleted,
      });
      print('Task completion status updated successfully');
    } catch (e) {
      print('Error updating task completion: $e');
    }
  }

  Future<void> saveFileToLocalStorage(File file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${file.uri.pathSegments.last}';
      final newFile = await file.copy(filePath);
      print('File saved locally at: $filePath');
    } catch (e) {
      print("Error saving file locally: $e");
    }
  }

  // Method to save a note to Firestore
  Future<void> saveNote(String noteContent, String noteTitle) async {
    try {
      // Adding a new note to Firestore under 'notes' collection
      await _firestore.collection('notes').add({
        'title': noteTitle,
        'content': noteContent,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Note saved successfully');
    } catch (e) {
      print('Error saving note: $e');
    }
  }

  // Method to retrieve all notes from Firestore
  Stream<List<Map<String, dynamic>>> getNotes() {
    return _firestore.collection('notes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add document ID for reference
          return data;
        }).toList());
  }

  // Method to delete a note by its ID
  Future<void> deleteNote(String noteId) async {
    try {
      // Delete the note by its ID
      await _firestore.collection('notes').doc(noteId).delete();
      print('Note deleted successfully');
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  // Method to update a note by its ID
  Future<void> updateNote(String noteId, String newContent, String newTitle) async {
    try {
      // Update the note with new content and title
      await _firestore.collection('notes').doc(noteId).update({
        'content': newContent,
        'title': newTitle,
      });
      print('Note updated successfully');
    } catch (e) {
      print('Error updating note: $e');
    }
  }




//New method with a different name to avoid conflict/ LIST_DROPDOWN
  Future<List<String>> fetchTaskListsForDropdown() async {
    QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
    List<String> taskLists = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    return taskLists;
  }

}









