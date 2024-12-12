
import 'package:flutter/material.dart';
import 'NotificationList.dart';
import 'firestore_service.dart';
//import 'notification.dart';
//import 'package:easy_assistance_app/Todo_task/notification.dart'; // Adjust path if necessary



class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _newListController = TextEditingController();



  String _selectedList = 'Default';
  List<String> _lists = ['Default', 'Work', 'Personal', 'Urgent', 'Shopping'];



  @override
  void initState() {
    super.initState();
    _loadTaskLists();
  }

  Future<void> _loadTaskLists() async {
    List<String> taskLists = await _firestoreService.getTaskLists();
    setState(() {
      _lists = ['Default'] + taskLists;
      _lists = _lists.toSet().toList(); // Remove duplicates
      if (!_lists.contains(_selectedList)) {
        _selectedList = 'Default'; // Ensure default value is valid
      }
    });
  }


  void _showAddListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New List'),
          content: TextField(
            controller: _newListController,
            decoration: InputDecoration(
              hintText: 'Enter list name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _newListController.clear();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_newListController.text.isNotEmpty) {
                  await _firestoreService.addNewTaskList(_newListController.text);
                  await _loadTaskLists(); // Reload lists to include the new one
                  setState(() {
                    _selectedList = _newListController.text;
                  });
                }
                Navigator.of(context).pop();
                _newListController.clear();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteList(String listName) async {
    // Delete the list from Firestore
    await _firestoreService.deleteTaskList(listName); // Delete from Firestore

    // Remove the list from the local list immediately
    setState(() {
      _lists.remove(listName); // Remove from the local list
      if (_selectedList == listName) {
        _selectedList = 'Default'; // Reset selected list if deleted
      }
    });

    // Close the dropdown menu programmatically
    Navigator.of(context).pop(); // Close the dropdown menu

    // Show a SnackBar with a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("List '$listName' deleted successfully !"), backgroundColor: Colors.green,),
    );
  }

  Future<void> _pickDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = '${pickedDate.day}, ${_getMonthName(pickedDate.month)} ${pickedDate.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (pickedTime != null) {
      setState(() {
        _timeController.text = '${pickedTime.format(context)}';
      });
    }
  }

  String _getMonthName(int month) {
    List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  void _clearFields() {
    setState(() {
      _taskController.clear();
      _dateController.clear();
      _timeController.clear();
      _selectedList = 'Default';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        toolbarHeight: 120,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "New Task",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What is to be done?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  hintText: 'Enter task',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Due Date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: _pickDate,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Select due date',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                readOnly: true,
              ),
              SizedBox(height: 20),

              Text(
                "Due Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: _pickTime,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Select due time',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                readOnly: true,
              ),
              SizedBox(height: 20),

              Text(
                "Add to List",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: DropdownButton<String>(
                        value: _lists.contains(_selectedList) ? _selectedList : null,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedList = newValue!;
                          });
                        },
                        items: _lists.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(value),
                                if (value != 'Default')
                                  IconButton(
                                    icon: Icon(Icons.delete, size: 20, color: Colors.black),
                                    onPressed: () {
                                      _deleteList(value);
                                    },
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        isExpanded: true,
                        hint: Text('Select a list'),
                      )
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.blue, size: 30),
                    onPressed: _showAddListDialog,
                  ),
                ],
              ),
              SizedBox(height: 40),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_taskController.text.isNotEmpty && _dateController.text.isNotEmpty && _timeController.text.isNotEmpty) {
                        try {
                          await _firestoreService.addTask(
                            _taskController.text,
                            _dateController.text,
                            _timeController.text,
                            _selectedList,
                          );

                          _clearFields();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task added successfully !'), backgroundColor: Colors.green,),
                          );
                        } catch (e) {
                          print('Error adding task: $e');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to add task !')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields !', style: TextStyle(color: Colors.black),), backgroundColor: Colors.yellow[600],),
                        );
                      }
                    },
                    child: Text('Add', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      backgroundColor: Colors.blue[900],
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),

                  // IconButton(
                  //   icon: Icon(Icons.notifications, color: Colors.blue, size: 30),
                  //   onPressed: () {
                  //     // Navigate to the NotificationPage
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => NotificationPage()),
                  //     );
                  //   },
                  // ),

                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _clearFields,
                    child: Text('Clear', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      backgroundColor: Colors.blue[900],
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}