import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_assistance_app/TodoTask_Service/firestore_service.dart';


class TaskListPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final FirestoreService _taskCompletionService = FirestoreService();

  TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        toolbarHeight: 95,
        // title: Text('Task List'),
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ), // Make the title text white

        ),
        iconTheme: IconThemeData(color: Colors.white), // Set the back arrow color to white
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.notifications, color: Colors.white, size: 30),
        //     onPressed: () {
        //       //showNotifications(context);
        //     },
        //   ),
        // ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found.'));
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              bool isFavorite = task['favorite'] ?? false; // Check if the task is marked as favorite

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(task['task'] ?? 'No Task'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due Date: ${task['dueDate'] ?? 'N/A'}'),
                      Text('Due Time: ${task['dueTime'] ?? 'N/A'}'),
                      Text('List: ${task['list'] ?? 'Default'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task['isCompleted'] ?? false,
                        onChanged: (bool? value) {
                          _taskCompletionService.toggleTaskCompletion(task['id'], value ?? false);
                        },
                        activeColor: Colors.green,  // Set the checkbox color to green when checked
                      ),

                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () async {
                          try {
                            await _firestoreService.deleteTask(task['id']);
                            // Show a SnackBar to indicate success
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Task deleted successfully !',
                                style: TextStyle(color: Colors.white), // Text color (optional)
                              ),
                                backgroundColor: Colors.green, // Set background color to green
                              ),
                            );
                          } catch (e) {
                            // Handle errors if any
                            SnackBar(content: Text('Failed to deleted task !',
                              style: TextStyle(color: Colors.white), // Text color (optional)
                            ),
                              backgroundColor: Colors.yellow, // Set background color to green

                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.yellow : Colors.black,
                        ),
                        onPressed: () {
                          _firestoreService.toggleFavorite(task['id'], !isFavorite);  // Toggle favorite status
                        },
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


