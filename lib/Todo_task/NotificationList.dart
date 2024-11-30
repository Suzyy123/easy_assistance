import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_assistance_app/Todo_task/firestore_service.dart';

class NotificationPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Task Notifications',
          style: TextStyle(color: Colors.white), // Make the title text white
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tasks to display.'),
            );
          }

          // Get tasks and categorize them
          final tasks = snapshot.data!;
          final now = DateTime.now();
          final overdueTasks = tasks.where((task) {
            final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
            return dueDate.isBefore(now);
          }).toList();

          final upcomingTasks = tasks.where((task) {
            final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
            return dueDate.isAfter(now) &&
                dueDate.difference(now).inDays <= 3; // Adjust range as needed
          }).toList();

          return ListView(
            children: [
              if (upcomingTasks.isNotEmpty)
                _buildTaskSection('Tasks Approaching Due Date', upcomingTasks, now, false),
              if (overdueTasks.isNotEmpty)
                _buildTaskSection('Overdue Tasks', overdueTasks, now, true),
            ],
          );
        },
      ),
    );
  }

  // Helper: Parse due date and time
  DateTime _parseDueDate(String dueDate, String dueTime) {
    return DateFormat('dd, MMM yyyy hh:mm a').parse('$dueDate $dueTime');
  }

  // Helper: Build a section for tasks
  Widget _buildTaskSection(String title, List<Map<String, dynamic>> tasks, DateTime now, bool isOverdue) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...tasks.map((task) {
              final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
              final difference = dueDate.difference(now).inDays;

              // If it's overdue, we don't show remaining days
              final status = isOverdue
                  ? 'Overdue' // Only show "Overdue" for overdue tasks
                  : '$difference day(s) remaining'; // Show remaining days for upcoming tasks

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  title: Text(task['task']),
                  subtitle: Text('Due: ${task['dueDate']} at ${task['dueTime']}'),
                  trailing: Text(
                    status,
                    style: TextStyle(
                      color: isOverdue ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
