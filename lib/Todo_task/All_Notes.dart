import 'package:flutter/material.dart';
import 'firestore_service.dart';

class NotesPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
        title: Text("Notes",
        style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes available.'));
          }

          var notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    note['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(note['content']),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editNote(context, note); // Open Edit functionality
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context, note['id']); // Delete functionality
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.black),
                            SizedBox(width: 8),
                            Text("Edit")
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.black),
                            SizedBox(width: 8),
                            Text("Delete")
                          ],
                        ),
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

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel deletion
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreService.deleteNote(noteId); // Delete the note
                Navigator.of(context).pop(); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Note deleted successfully!'),
                    backgroundColor: Colors.green, // Green color for success
                  ),
                );
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Method to handle note editing (opens an edit screen)
  void _editNote(BuildContext context, Map<String, dynamic> note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(note: note, firestoreService: _firestoreService),
      ),
    );
  }
}

class EditNotePage extends StatefulWidget {
  final Map<String, dynamic> note;
  final FirestoreService firestoreService;  // Pass the FirestoreService here

  EditNotePage({required this.note, required this.firestoreService}); // Constructor

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title']);
    _contentController = TextEditingController(text: widget.note['content']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateNote() {
    widget.firestoreService.updateNote(  // Use the FirestoreService instance passed to this page
      widget.note['id'],
      _contentController.text,
      _titleController.text,
    );
    Navigator.pop(context); // Close the edit page

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note updated successfully!'),
        backgroundColor: Colors.green, // Green color for success
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Edit Note",
        style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white), // Change back arrow color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: "Title",
                labelStyle: TextStyle(color: Colors.blue[400]), // Set label color
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!), // Set focused border color
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Content",
                labelStyle: TextStyle(color: Colors.blue[400]), // Set label color
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!), // Focused border color
                ),
              ),
              maxLines: 6,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800], // Set the background color of the button
              ),
              child: Text("Save",
              style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
