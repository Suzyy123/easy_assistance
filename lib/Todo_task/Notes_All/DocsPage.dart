import 'package:flutter/material.dart';
import 'package:easy_assistance_app/TodoTask_Service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'All_Notes.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // Controllers to capture text input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Method to save the note
  Future<void> _saveNote() async {
    final String noteTitle = _titleController.text;
    final String noteContent = _contentController.text;

    //New
    User? user = FirebaseAuth.instance.currentUser;
    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not logged in! Please log in to save a note.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    //new
    final String userId = user.uid;
    if (noteTitle.isNotEmpty && noteContent.isNotEmpty) {
      await FirestoreService().saveNote(noteContent, noteTitle, userId);
      // FirestoreService().saveNote(noteContent, noteTitle);
      // Clear the text fields after saving the note
      _titleController.clear();
      _contentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note saved successfully !'),
          backgroundColor: Colors.green,),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both title and content !', style: TextStyle(color: Colors.black),), backgroundColor: Colors.yellow[600],),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
        title: Text('Write a Note',
          style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title TextField
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Note Title',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                labelStyle: TextStyle(color: Colors.grey), // Label text color
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Border color when focused
                ),
              ),
            ),
            SizedBox(height: 16),
            // Content TextField
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Note Content',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Border color when focused
                ),
              ),
              maxLines: 5, // Allows multiple lines for note content
            ),
            // SizedBox(height: 16),
            // // Save button
            // ElevatedButton(
            //   onPressed: _saveNote,
            //   child: Text(
            //     'Save Note',
            //     style: TextStyle(color: Colors.white), // Text color
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue[900], // Background color of the button
            //   ),
            // )
            SizedBox(height: 16),
// Save button
            ElevatedButton(
              onPressed: () {
                _saveNote(); // Call the function to save the note

                // Navigate to the NotesPage after saving the note
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NotesPage()), // Replace with your NotesPage widget
                );
              },
              child: Text(
                'Save Note',
                style: TextStyle(color: Colors.white), // Text color
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900], // Background color of the button
              ),
            ),

          ],
        ),
      ),
    );
  }
}
