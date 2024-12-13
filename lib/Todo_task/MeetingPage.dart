
import 'package:easy_assistance_app/ChatPage/chatfucntions.dart';
import 'package:easy_assistance_app/Pages/chatscreen.dart';
import 'package:easy_assistance_app/Todo_task/frontPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ChatPage/ChatPageUI.dart';
import 'package:easy_assistance_app/TodoTask_Service/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'AcceptDenyPage.dart';

class MeetingsPage extends StatefulWidget {
  @override
  _MeetingsPageState createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  final FirestoreService _firestoreService = FirestoreService();

  // Method to navigate to the Accept/Deny page when meetingId is clicked
  void _navigateToAcceptDenyPage(String meetingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptDenyPage(meetingId: meetingId),
      ),
    );
  }

  // Method to handle delete action with confirmation
  void _deleteMeeting(String meetingId) async {
    // Show a confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel',
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete',
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),
          ],
        );
      },
    );

    // If confirmed, proceed with deletion
    if (confirm == true) {
      await _firestoreService.deleteMeeting(meetingId);
      setState(() {}); // Refresh the list
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meeting deleted successfully!'),
          backgroundColor: Colors.green, // Set the background color to green
        ),
      );
    }
  }

  // Method to handle edit action (show dialog with pickers)
  void _editMeeting(String meetingId, String title, String description, String date, String time, String location) {
    final _formKey = GlobalKey<FormState>();
    String _editedTitle = title;
    String _editedDescription = description;
    String _editedDate = date;
    String _editedTime = time;
    String _editedLocation = location;

    // Show dialog for editing the meeting
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Edit Meeting', style: TextStyle(color: Colors.blue[900]),),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: _editedTitle,
                    decoration: InputDecoration(labelText: 'Title', labelStyle: TextStyle(color: Colors.grey)),
                    onSaved: (value) => _editedTitle = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _editedDescription,
                    decoration: InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.grey)),
                    onSaved: (value) => _editedDescription = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  // Date Picker
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Date', labelStyle: TextStyle(color: Colors.grey)),
                    controller: TextEditingController(text: _editedDate),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(_editedDate),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _editedDate = '${selectedDate.toLocal()}'.split(' ')[0];
                        });
                      }
                    },
                  ),
                  // Time Picker
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Time', labelStyle: TextStyle(color: Colors.grey)),
                    controller: TextEditingController(text: _editedTime),
                    onTap: () async {
                      String time = _editedTime.isNotEmpty ? _editedTime : '12:00'; // Default time
                      TimeOfDay initialTime = TimeOfDay(
                        hour: int.parse(time.split(':')[0]),
                        minute: int.parse(time.split(':')[1]),
                      );
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _editedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                  // Location (Dropdown)
                  DropdownButtonFormField<String>(
                    value: _editedLocation,
                    onChanged: (newValue) {
                      setState(() {
                        _editedLocation = newValue!;
                      });
                    },
                    items: ['Virtual', 'In-Person'].map((location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Update the meeting
                    await _firestoreService.editMeeting(
                      meetingId,
                      _editedTitle,
                      _editedDescription,
                      _editedDate,
                      _editedTime,
                      _editedLocation,
                    );
                    // Close the dialog and refresh the list
                    Navigator.pop(context);
                    setState(() {});

                    // Show success message after the meeting is updated
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Meeting updated successfully!'),
                        backgroundColor: Colors.green, // Set the background color to green
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: Text('Update', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareMeeting(String meetingId) async {
    // Your dynamic link URI prefix and link to handle the meeting ID
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://easyassistance.page.link',  // Dynamic link URI prefix
      link: Uri.parse('https://easyassistance.page.link/meeting_invitation_link?meetingId=$meetingId'),  // Full dynamic link with meetingId parameter

      androidParameters: AndroidParameters(
        packageName: 'com.example.easy_assistance_app',  // Replace with your Android package name
        minimumVersion: 1,
      ),
    );

    // Create the dynamic link
    final Uri dynamicUrl = await FirebaseDynamicLinks.instance.buildLink(parameters);

    // Show the dialog with the dynamic link
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share Meeting'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Meeting Link:'),
              GestureDetector(
                onTap: () {
                  //Instead of opening an external link, navigate to the AcceptDenyPage within the app
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AcceptDenyPage(meetingId: meetingId),
                  //   ),
                  // );

                    // Launch the dynamic URL
                    launch(dynamicUrl.toString());
                },
                child: Text(
                  dynamicUrl.toString(),
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Meeting ID: $meetingId'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the current dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()), // Navigate to ChatPage
                );
              },
              child: Text('OK'),
            ),

            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: dynamicUrl.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Meeting link copied to clipboard!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Copy Link', style: TextStyle(color: Colors.blue[900])),
            ),
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: meetingId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Meeting ID copied to clipboard!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Copy ID', style: TextStyle(color: Colors.blue[900])),
            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meetings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Map<String, dynamic>>>( // Using stream
          stream: _firestoreService.getMeetings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No meetings found.'));
            }

            List<Map<String, dynamic>> meetings = snapshot.data!;

            return ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                var meeting = meetings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 8),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      title: Text(meeting['title'] ?? 'No Title'),
                      subtitle: Text(
                        '${meeting['date']} at ${meeting['time']}, Location: ${meeting['location']}',
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editMeeting(
                              meeting['id'],
                              meeting['title'],
                              meeting['description'],
                              meeting['date'],
                              meeting['time'],
                              meeting['location'],
                            );
                          } else if (value == 'delete') {
                            _deleteMeeting(meeting['id']);
                          } else if (value == 'share') {
                            _shareMeeting(meeting['id']);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'share',
                              child: Row(
                                children: [
                                  Icon(Icons.share, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('Share'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
