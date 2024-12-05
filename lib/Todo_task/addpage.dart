import 'package:flutter/material.dart';
import 'firestore_service.dart'; // Import your FirestoreService

class Addpage extends StatefulWidget {
  @override
  _AddpageState createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> _taskNames = [];

  @override
  void initState() {
    super.initState();
    _loadTaskLists(); // Fetch task lists when the widget is initialized
  }

  // Fetch task names from Firebase
  Future<void> _loadTaskLists() async {
    List<String> taskLists = await _firestoreService.getTaskLists();
    setState(() {
      _taskNames = taskLists;
    });
  }

  // The task list container to show the fetched task names
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 300,
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for Home icon and All Lists text
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Add logic for Home button action if needed
                },
              ),
              SizedBox(width: 8), // Space between Home icon and All Lists text
              Text(
                'All Lists',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          Divider(thickness: 1.5, color: Colors.grey),
          SizedBox(height: 8),
          // List of task names with Menu icon on the left
          Expanded(
            child: _taskNames.isEmpty
                //? Center(child: CircularProgressIndicator()) // Loading state
                ? Container() // No loading sign, just empty space
                : ListView.builder(
              itemCount: _taskNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          // Logic for each task's menu icon
                        },
                      ),
                      SizedBox(width: 2),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          _taskNames[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Add New List option
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.add_card_outlined),
                SizedBox(width: 8),
                Text('Add New List', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          // Add New List option
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.add_card_outlined),
                SizedBox(width: 8),
                Text('Finished', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}