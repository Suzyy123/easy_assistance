import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'FirestoreService.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskId;
  final String taskName;

  TaskDetailPage({required this.taskId, required this.taskName});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final FirestoreService _firestoreService = FirestoreService(); // Firestore instance

  // Method to determine progress based on task status
  double getProgress(String status) {
    switch (status) {
      case 'In progress':
        return 0.5;
      case 'Done':
        return 1.0;
      default:
        return 0.0;
    }
  }

  // Method to update task status in Firestore
  Future<void> _updateStatus(String newStatus) async {
    try {
      await _firestoreService.updateTaskStatus(widget.taskId, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task status updated to "$newStatus"'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // StreamBuilder to listen for task status updates in real-time
            StreamBuilder<DocumentSnapshot>(
              stream: _firestoreService.getTaskStream(widget.taskId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('Task not found');
                }

                var taskData = snapshot.data!.data() as Map<String, dynamic>;
                String taskStatus = taskData['status'] ?? 'Not started'; // Default to 'Not started'

                return Column(
                  children: [
                    // Progress Bar based on task status
                    LinearProgressIndicator(
                      value: getProgress(taskStatus),
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 10,
                    ),
                    SizedBox(height: 20),
                    // Checkboxes for changing the task status
                    Column(
                      children: [
                        CheckboxListTile(
                          title: Text('Not started'),
                          value: taskStatus == 'Not started',
                          onChanged: (value) {
                            if (value == true) _updateStatus('Not started');
                          },
                        ),
                        CheckboxListTile(
                          title: Text('In progress'),
                          value: taskStatus == 'In progress',
                          onChanged: (value) {
                            if (value == true) _updateStatus('In progress');
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Done'),
                          value: taskStatus == 'Done',
                          onChanged: (value) {
                            if (value == true) _updateStatus('Done');
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
