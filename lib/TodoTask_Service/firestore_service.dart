import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


  // Method to add a new task to both 'tasks' and 'taskLists' collections
  Future<void> addTask(String task, String dueDate, String dueTime, String list, String user) async {
    try {
      // Format dueDate
      String formattedDueDate = DateFormat('dd, MMM yyyy').format(DateFormat('dd, MMM yyyy').parse(dueDate.trim()));

      // Format dueTime
      String formattedDueTime = DateFormat('HH:mm').format(DateFormat('HH:mm').parse(dueTime.trim()));

      // Add task to Firestore
      await _firestore.collection('tasks').add({
        'UserId': user,
        'task': task,
        'dueDate': formattedDueDate,
        'dueTime': formattedDueTime,
        'list': list,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }


  // Method to retrieve tasks from Firestore/ TasksListPAge
  Stream<List<Map<String, dynamic>>> getTasks(String UserId) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('UserId', isEqualTo: UserId) // **(RED)** Filter tasks by userId
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
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


  // Fetch current users  lists from Firestore LISTS
  Future<List<String>> getTaskLists(String userId) async {
    try {
      // Fetch task lists specific to the user
      QuerySnapshot snapshot = await _firestore
          .collection('taskLists')
          .where('UserId', isEqualTo: userId) // Filter by UserId
          .get();

      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print("Error fetching task lists for user $userId: $e");
      return [];
    }
  }



  // it use is to retrive task and check whether overdue or remaing date
  Future<List<Map<String, dynamic>>> getTasksForDate(DateTime date, String userId) async {
    try {
      // Format the date to match the format stored in Firestore
      String formattedDate = DateFormat('dd, MMM yyyy').format(date);

      // Query tasks for the selected date and user
      QuerySnapshot snapshot = await _firestore.collection('tasks')
          .where('dueDate', isEqualTo: formattedDate) // Filter by due date
          .where('UserId', isEqualTo: userId)        // Filter by UserId
          .get();

      // Map the snapshot data into a list of tasks
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for reference
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching tasks for user $userId on date : $e');
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
  // Method to fetch tasks that are marked as favorite for a specific user
  Stream<List<Map<String, dynamic>>> getFavoriteTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('favorite', isEqualTo: true) // Filter tasks where favorite is true
        .where('UserId', isEqualTo: userId) // Filter tasks belonging to the current user
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add document ID for reference
          return data;
        }).toList());
  }


  // Method to fetch completed tasks/Completed Tasks
  Stream<List<Map<String, dynamic>>> getCompletedTasks(String userId) {
    return _firestore.collection('tasks')
        .where('isCompleted', isEqualTo: true) // Filter completed tasks
        .where('UserId', isEqualTo: userId) // Filter tasks belonging to the specific user
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
    } catch (e) {
      print('Error updating task completion: $e');
    }
  }


  //Add a new  tasklist to Firestore/
  Future<void> addNewTaskList(String listName, String User) async {
    try {
      await _firestore.collection('taskLists').add({
        'UserId': User,
        'name': listName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("New task list added successfully.");
    } catch (e) {
      print("Error adding new list: $e");
    }
  }
  // Method to delete a task list permanently from Firestore
  Future<void> deleteTaskList(String listName, String userId) async {
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

  //method to save meeting
  Future<void> addMeeting(String title, String description, String date, String time, String location, String userId) async {
    try {

      DocumentReference meetRef = await _firestore.collection('meetings').add({
        'UserId': userId,
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

// Stream method to fetch meetings for a specific user from Firestore
  Stream<List<Map<String, dynamic>>> getMeetings(String userId) {
    return _firestore
        .collection('meetings')
        .where('UserId', isEqualTo: userId) // Filter meetings by the current userId
        .snapshots()
        .map((snapshot) =>
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
  Future<void> editMeeting(String meetingId, String title, String description, String date, String time, String location, String UserId) async {
    try {
      // Update the meeting with the new values
      await _firestore.collection('meetings').doc(meetingId).update({
        'UserId': UserId,
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


  // Method to save a note to Firestore
  Future<void> saveNote(String noteContent, String noteTitle, String userId) async {
    try {
      // Adding a new note to Firestore under 'notes' collection
      await _firestore.collection('notes').add({
        'UserId': userId,
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
  Stream<List<Map<String, dynamic>>> getNotes(String userId) {
    return _firestore
        .collection('notes')
        .where('UserId', isEqualTo: userId) // Filter notes by the current user's ID
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add document ID for reference
          return data;
        }).toList());
  }


  // Method to delete a note by its ID
  Future<void> deleteNote(String noteId, String userId) async {
    try {
      // Delete the note by its ID
      await _firestore.collection('notes').doc(noteId).delete();
      print('Note deleted successfully');
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  // Method to update a note by its ID
  Future<void> updateNote(String noteId, String newContent, String newTitle, String userId) async {
    try {
      // Fetch the document to validate the userId
      DocumentSnapshot noteSnapshot = await _firestore.collection('notes').doc(noteId).get();

      // Check if the note belongs to the current user
      if (noteSnapshot.exists && noteSnapshot.get('UserId') == userId) {
        // Update the note with new content and title
        await _firestore.collection('notes').doc(noteId).update({
          'content': newContent,
          'title': newTitle,
        });
        print('Note updated successfully');
      } else {
        print('Unauthorized: This note does not belong to the current user.');
        throw Exception('Unauthorized access');
      }
    } catch (e) {
      print('Error updating note: $e');
    }
  }




// //New method with a different name to avoid conflict/ LIST_DROPDOWN
//   Future<List<String>> fetchTaskListsForDropdown() async {
//     QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
//     List<String> taskLists = snapshot.docs.map((doc) => doc['name'].toString()).toList();
//     return taskLists;
//   }

}









