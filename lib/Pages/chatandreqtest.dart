import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 0; // For bottom navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/profile_image.jpg'), // Placeholder
        ),
        title: Text(
          _selectedIndex == 0 ? "Messages Page" : "Request Page",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {}, // Menu functionality
          ),
        ],
      ),
      body: _selectedIndex == 0 ? const MessagesPage() : const RequestPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Requests',
          ),
        ],
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // Placeholder for message count
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar_placeholder.jpg'),
                ),
                title: Text("User $index"),
                subtitle: const Text("How are you?"),
                trailing: const Text("4h ago"),
                onTap: () {
                  // Navigate to chat
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/avatar_placeholder.jpg'),
          ),
          title: const Text("Hanagaki Takemichi"),
          subtitle: const Text("Python Developer"),
          trailing: ElevatedButton(
            onPressed: () {
              // Accept functionality
            },
            child: const Text("Accept"),
          ),
        ),
      ],
    );
  }
}
