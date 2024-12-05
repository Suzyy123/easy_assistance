import 'package:flutter/material.dart';
import 'firestore_service.dart'; // Import the Firestore service for fetching tasks

class FavoriteTasksPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 95,
        title: const Text(
          'Favorite Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getFavoriteTasks(), // Fetch favorite tasks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite tasks found.'));
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow, // Display star icon for favorites
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
