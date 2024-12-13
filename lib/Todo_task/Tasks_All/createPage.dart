import 'package:flutter/material.dart';
import 'package:easy_assistance_app/TodoTask_Service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'TaskListPage.dart';

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
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String _selectedList = 'Default';
  List<String> _lists = ['Default', 'Work', 'Personal', 'Urgent', 'Shopping'];

  @override
  void initState() {
    super.initState();
    _loadTaskLists();
  }

  Future<void> _loadTaskLists() async {
    try {
      List<String> taskLists = await _firestoreService.getTaskLists(userId);
      setState(() {
        _lists = ['Default', 'Work', 'Personal', 'Urgent', 'Shopping'];
        _lists.addAll(taskLists.map((list) => list.trim()));
        _lists = _lists.toSet().toList();
        if (!_lists.contains(_selectedList)) {
          _selectedList = 'Default';
        }
      });
    } catch (e) {
      debugPrint('Error loading task lists: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load task lists!"), backgroundColor: Colors.red),
      );
    }
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
                  await _firestoreService.addNewTaskList(_newListController.text, userId);
                  await _loadTaskLists();
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
    try {
      await _firestoreService.deleteTaskList(listName, userId);
      setState(() {
        _lists.remove(listName);
        if (_selectedList == listName) {
          _selectedList = 'Default';
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("List '$listName' deleted successfully!"), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint('Error deleting list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete list!"), backgroundColor: Colors.red),
      );
    }
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
        _dateController.text = DateFormat('dd, MMM yyyy').format(pickedDate);
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
      final now = DateTime.now();
      final pickedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        _timeController.text = DateFormat('HH:mm').format(pickedDateTime);
      });
    }
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
                  suffixIcon: Icon(Icons.task),
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
                    ),
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
                      if (_taskController.text.isNotEmpty &&
                          _dateController.text.isNotEmpty &&
                          _timeController.text.isNotEmpty) {
                        try {
                          await _firestoreService.addTask(
                            _taskController.text,
                            _dateController.text,
                            _timeController.text,
                            _selectedList,
                            userId,
                          );
                          _clearFields();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task added successfully!'), backgroundColor: Colors.green),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TaskListPage()),
                          );
                        } catch (e) {
                          debugPrint('Error adding task: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to add task!')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields!'), backgroundColor: Colors.yellow[600]),
                        );
                      }
                    },
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _clearFields,
                    child: Text('Clear', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
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
