import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy messages for the chat list
    final List<Map<String, String>> messages = [

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
