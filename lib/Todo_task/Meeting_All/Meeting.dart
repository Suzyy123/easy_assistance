import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MeetingPage.dart';

class CreateMeetingPage extends StatefulWidget {
  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedLocation = 'Virtual'; // Default location
  String user = FirebaseAuth.instance.currentUser!.uid;

  // Format Date and Time for display
  String get formattedDate =>
      _selectedDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_selectedDate!);

  String get formattedTime =>
      _selectedTime == null ? 'Select Time' : _selectedTime!.format(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Meeting', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: IconThemeData(
          color: Colors.white, // Ensure all icons in the AppBar are white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Meeting Title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Meeting Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Meeting Description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Date Picker
              GestureDetector(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(formattedDate),
                ),
              ),
              SizedBox(height: 16),

              // Time Picker
              GestureDetector(
                onTap: _pickTime,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(formattedTime),
                ),
              ),
              SizedBox(height: 16),

              // Location Dropdown
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                items: ['Virtual', 'In-Person'].map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 75), // Increase space for the buttons

              // Create and Cancel buttons side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cancel Button
                  SizedBox(
                    width: 150, // Increase the width of the button
                    child: ElevatedButton(
                      onPressed: _cancelMeeting,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Same color as Create button
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 16), // Add some space between the buttons

                  // Create Meeting Button
                  SizedBox(
                    width: 150, // Increase the width of the button
                    child: ElevatedButton(
                      onPressed: _createMeeting,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Same color as Cancel button
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Create', style: TextStyle(fontSize: 18, color: Colors.white)),
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

  // Date Picker
  Future<void> _pickDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  // Time Picker
  Future<void> _pickTime() async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selected != null && selected != _selectedTime) {
      setState(() {
        _selectedTime = selected;
      });
    }
  }

  // Cancel Meeting function
  void _cancelMeeting() {
    setState(() {
      // Clear all input fields
      _titleController.clear();
      _descriptionController.clear();
      _selectedDate = null;
      _selectedTime = null;
      _selectedLocation = 'Virtual';
      // Reset to default location
    });
    print('Meeting Creation Canceled');
  }

  // Create Meeting function with validation and success/error handling
  void _createMeeting() {
    if (_titleController.text.isEmpty) {
      // If the title is empty, show an alert
      _showErrorDialog('Meeting Title cannot be empty.');
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      // If either date or time is not selected, show an alert
      _showErrorDialog('Please select both date and time for the meeting.');
      return;
    }

    // Save meeting to Firebase directly
    FirebaseFirestore.instance.collection('meetings').add({
      'UserId': user,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': formattedDate,
      'time': formattedTime,
      'location': _selectedLocation,
      'created_at': FieldValue.serverTimestamp(),
    }).then((_) {
      // On success, show success dialog
      _showSuccessDialog();
    }).catchError((error) {
      // On error, show error dialog
      _showErrorDialog('Failed to create meeting. Please try again.');
    });
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Meeting created successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelMeeting(); // Clear fields after success

                // Navigate to the MeetingsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeetingsPage()), // Replace with your MeetingsPage widget
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
