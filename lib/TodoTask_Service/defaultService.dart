import 'package:flutter/material.dart';
import 'firestore_service.dart';
 // Import the new service

class DefaultListPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final FirestoreService _taskCompletionService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 95, // Adjust the height if necessary
        title: const Text(
          'Default List',
          style: TextStyle(
            color: Colors.black,       // White color for the title text
            fontSize: 27,              // Font size set to 27
            fontWeight: FontWeight.bold, // Bold font weight for the title
          ),
        ),
        backgroundColor: Colors.white, // Set the app bar background color
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.notifications, color: Colors.white, size: 30), // Notification icon
        //     onPressed: () {
        //       // Optionally handle notifications
        //     },
        //   ),
        // ],
      ),
      backgroundColor: Colors.white, // Background color of scaffold

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getTasks(), // Fetch all tasks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found in Default list.'));
          }

          // Filter tasks to only those with "Shopping" list
          final defaultTasks = snapshot.data!
              .where((task) => task['list'] == 'Default') // Filter by 'Shopping' list
              .toList();

          if (defaultTasks.isEmpty) {
            return Center(child: Text('No tasks found in Default list.'));
          }

          // Display only shopping tasks
          return ListView.builder(
            itemCount: defaultTasks.length,
            itemBuilder: (context, index) {
              final task = defaultTasks[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    task['task'] ?? 'No Task',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Bold task title
                      fontSize: 18, // Set task title font size
                    ),
                  ),
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
                        onPressed: () {
                          //_taskCompletionService.deleteTask(task['id']);

                          // Show the snackbar after deletion
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('This task has been deleted'),
                              backgroundColor: Colors.green, // Green for success
                              duration: Duration(seconds: 2),
                            ),
                          );
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
