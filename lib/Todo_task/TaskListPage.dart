import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'notification.dart';

class TaskListPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        backgroundColor: Colors.blue[800],

        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 30),
            onPressed: () {
              showNotifications(context); // Use the correct function
            },
          ),
        ],


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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
