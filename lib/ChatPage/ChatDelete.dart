import 'package:flutter/material.dart';

class DeleteChatPage extends StatelessWidget {
  const DeleteChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> confirmDeleteChat() async {
      bool confirm = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Chat"),
            content: Text("Are you sure you want to delete all chats?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true); // Close the dialog
                  // Implement the delete functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chats deleted successfully')),
                  );
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );

      if (confirm) {
        // Perform any additional deletion logic here
        print("Delete chat triggered.");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Chats"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: confirmDeleteChat,
          child: Text("Delete All Chats"),
        ),
      ),
    );
  }
}
