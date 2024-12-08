import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy messages for the chat list
    final List<Map<String, String>> messages = [
      {
        "name": "Alice",
        "lastMessage": "Hey, how are you?",
        "time": "10:30 AM",
        "imageUrl": "https://via.placeholder.com/150",
      },
      {
        "name": "Bob",
        "lastMessage": "Let's catch up later.",
        "time": "9:15 AM",
        "imageUrl": "https://via.placeholder.com/150",
      },
      {
        "name": "Charlie",
        "lastMessage": "Did you complete the task?",
        "time": "Yesterday",
        "imageUrl": "https://via.placeholder.com/150",
      },
      {
        "name": "Diana",
        "lastMessage": "Happy Birthday!",
        "time": "2 days ago",
        "imageUrl": "https://via.placeholder.com/150",
      },
    ];

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(message['imageUrl']!),
            radius: 25,
          ),
          title: Text(
            message['name']!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message['lastMessage']!),
          trailing: Text(
            message['time']!,
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            // Add navigation to chat detail page if needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Chat with ${message['name']}")),
            );
          },
        );
      },
    );
  }
}
