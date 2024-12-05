import 'package:flutter/material.dart';
import 'firestore_service.dart'; // Adjust the import as necessary

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // Controllers to capture text input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Method to save the note
  void _saveNote() {
    final String noteTitle = _titleController.text;
    final String noteContent = _contentController.text;

    if (noteTitle.isNotEmpty && noteContent.isNotEmpty) {
      FirestoreService().saveNote(noteContent, noteTitle);
      // Clear the text fields after saving the note
      _titleController.clear();
      _contentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note saved successfully !'), backgroundColor: Colors.green,),
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
        backgroundColor: Colors.blue[800],
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
                labelStyle: TextStyle(color: Colors.blue), // Label text color
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
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Border color when focused
                ),
              ),
              maxLines: 5, // Allows multiple lines for note content
            ),
            SizedBox(height: 16),
            // Save button
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(
                'Save Note',
                style: TextStyle(color: Colors.white), // Text color
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color of the button
              ),
            )
          ],
        ),
      ),
    );
  }
}
