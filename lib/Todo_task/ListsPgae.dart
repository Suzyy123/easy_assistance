import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_assistance_app/TodoTask_Service/firestore_service.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> taskLists = []; // To hold the task lists from Firebase
  bool isLoading = true; // To show a loading indicator while fetching data
  final TextEditingController _listNameController = TextEditingController();
  String userId= FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchTaskLists();
  }

  // Method to fetch task lists from Firestore and update the UI
  void fetchTaskLists() async {
    try {
      List<String> lists = await _firestoreService.getTaskLists(userId);
      setState(() {
        taskLists = lists;
        isLoading = false;  // Stop showing the loading indicator
      });
    } catch (e) {
      print('Error fetching task lists: $e');
      setState(() {
        isLoading = false;  // Stop showing the loading indicator in case of an error
      });
    }
  }

  // Method to add a task list
  void addTaskList() async {
    String listName = _listNameController.text.trim();
    if (listName.isNotEmpty) {
      try {
        await _firestoreService.addNewTaskList(listName, userId);  // Add the list to Firestore
        setState(() {
          taskLists.add(listName);  // Add the list to the local UI list
        });
        _listNameController.clear();  // Clear the input field
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$listName added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error adding task list: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding $listName'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method to delete a task list and update the UI after deletion
  Future<void> deleteTaskList(String listName) async {
    try {
      await _firestoreService.deleteTaskList(listName, userId);  // Call the FirestoreService delete method
      setState(() {
        taskLists.remove(listName);  // Remove the list from the UI after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$listName deleted successfully !',
            style: TextStyle(color: Colors.white),  // Set text color to white
          ),
          backgroundColor: Colors.green,  // Set the background color to green
        ),
      );
    } catch (e) {
      print('Error deleting task list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting $listName')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],  // Set the appbar color to blue
        title: Text('Task Lists',
          style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Show loading indicator while fetching data
          : taskLists.isEmpty
          ? Center(child: Text('No task lists found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),  // Add padding to the page
        child: Container(
          padding: const EdgeInsets.all(16.0),  // Add padding inside the container
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),  // Shadow position
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Lists',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: taskLists.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          taskLists[index],
                          style: TextStyle(fontSize: 16),
                        ),
                        // trailing: Icon(Icons.chevron_right),
                        // onTap: () {
                        //   // You can add actions here when a task list is tapped
                        //   print('Tapped on ${taskLists[index]}');

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.blue[900]),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete Task List'),
                                    content: Text('Are you sure you want to delete,  ${taskLists[index]}? '),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('Cancel', style: TextStyle(color: Colors.blue[900]),),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteTaskList(taskLists[index]);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete', style: TextStyle(color: Colors.blue[900]),),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // onTap: () {
                        // You can add actions here when a task list is tapped
                        // print('Tapped on ${taskLists[index]}');
                        // Navigate to TaskListDetailsPage when a task list is tapped
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       //builder: (context) => TaskListDetailsPage(listName: taskLists[index]),
                        //     ),
                        //   );
                        // },

                      ),
                    );
                  },
                ),
              ),
              // Icon at the bottom
              Padding(
                //padding: const EdgeInsets.all(90.0),
                padding: const EdgeInsets.only(bottom: 220.0),  // Add padding to raise the icon
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue[900], size: 50),
                    onPressed: () {
                      // Show a dialog to input the new list name
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add Task List'),
                            content: TextField(
                              controller: _listNameController,
                              decoration: InputDecoration(hintText: 'Enter list name'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();  // Close the dialog
                                },
                                child: Text('Cancel', style: TextStyle(color: Colors.black),),
                              ),
                              TextButton(
                                onPressed: () {
                                  addTaskList();  // Add the new list
                                  Navigator.of(context).pop();  // Close the dialog
                                },
                                child: Text('Add', style: TextStyle(color: Colors.black),),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
