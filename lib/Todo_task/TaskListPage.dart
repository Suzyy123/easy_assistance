import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../TodoTask_Service/firestore_service.dart';
import 'TaskDetailPage.dart';
import 'TaskDetailPage.dart';

class TaskListPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Helper function to parse the date string
  DateTime? parseDate(String dateStr) {
    try {
      // Assuming the date format is 'd, MMM yyyy'
      return DateFormat('d, MMM yyyy').parse(dateStr);
    } catch (e) {
      return null; // If the date format is incorrect, return null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        toolbarHeight: 95,
        title: const Text(
          'All Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Dynamic Progress Bar
          StreamBuilder<double>(  // Real-time progress bar based on task completion percentage
            stream: _firestoreService.getTaskCompletionPercentage(),
            builder: (context, snapshot) {
              double progress = snapshot.data ?? 0.0;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    SizedBox(height: 8),
                    Text('${(progress * 100).toStringAsFixed(1)}% tasks completed'),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(  // Fetch task data from Firestore in real-time
              stream: _firestoreService.getTasks(userId),
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
                    bool isFavorite = task['favorite'] ?? false;

                    // Parsing the due date string
                    DateTime? dueDate = parseDate(task['dueDate'] ?? '');

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        // Handle onTap for navigation to TaskDetailPage
                        onTap: () {
                          // Navigate to TaskDetailPage when other parts of the task are clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailPage(
                                taskId: task['id'],
                                taskName: task['task'] ?? 'No Task',
                              ),
                            ),
                          );
                        },
                        title: Text(task['task'] ?? 'No Task'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due Date: ${dueDate != null ? DateFormat('d MMM yyyy').format(dueDate) : 'No Date'}',
                            ),
                            Text('Due Time: ${task['dueTime'] ?? 'N/A'}'),
                            Text('List: ${task['list'] ?? 'Default'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Task Completion Checkbox (Enable for manual changes)
                            Checkbox(
                              value: task['isCompleted'] ?? false,
                              onChanged: (bool? value) async {
                                if (value != null) {
                                  try {
                                    await _firestoreService.toggleTaskCompletion(
                                      task['id'],
                                      value,
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to update completion status!',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            // Delete button
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () async {
                                try {
                                  await _firestoreService.deleteTask(task['id']);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Task deleted successfully!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to delete task!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                            // Favorite button
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.yellow : Colors.black,
                              ),
                              onPressed: () {
                                _firestoreService.toggleFavorite(task['id'], !isFavorite);
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
          ),
        ],
      ),
    );
  }
}
