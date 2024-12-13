import 'package:flutter/material.dart';

void main() {
  runApp(const MessagingApp());
}

class MessagingApp extends StatelessWidget {
  const MessagingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatListScreen(),
    );
  }
}

// Screen 1: Main Chat List
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const NewChatScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NewGroupChatScreen()));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Text('A')),
            title: const Text('Alice'),
            subtitle: const Text('Hey, how are you?'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MessagingScreen(chatName: 'Alice')));
            },
          ),
          ListTile(
            leading: const CircleAvatar(child: Text('G')),
            title: const Text('Group Chat'),
            subtitle: const Text('Let’s meet at 5 PM.'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MessagingScreen(chatName: 'Group Chat')));
            },
          ),
        ],
      ),
    );
  }
}

// Screen 2: Messaging Window
class MessagingScreen extends StatelessWidget {
  final String chatName;

  const MessagingScreen({super.key, required this.chatName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                ChatBubble(
                  text: 'Hi there!',
                  isSender: true,
                ),
                ChatBubble(
                  text: 'Hello!',
                  isSender: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Send message logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Bubble Widget
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const ChatBubble({super.key, required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSender ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

// Screen 3: Create New Chat
class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: const Center(
        child: Text('Search and select a contact to start a chat.'),
      ),
    );
  }
}

// Screen 4: Create New Group Chat
class NewGroupChatScreen extends StatelessWidget {
  const NewGroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group Chat'),
      ),
      body: const Center(
        child: Text('Select multiple contacts and create a group.'),
      ),
    );
  }
}