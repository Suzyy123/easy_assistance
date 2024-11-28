import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
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
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/profile_image.jpg'), // Placeholder
        ),
        title: Text(
          _selectedIndex == 0 ? "Messages Page" : "Request Page",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {}, // Menu functionality
          ),
        ],
      ),
      body: _selectedIndex == 0 ? MessagesPage() : RequestPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
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
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar_placeholder.jpg'),
                ),
                title: Text("User $index"),
                subtitle: Text("How are you?"),
                trailing: Text("4h ago"),
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
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar_placeholder.jpg'),
          ),
          title: Text("Hanagaki Takemichi"),
          subtitle: Text("Python Developer"),
          trailing: ElevatedButton(
            onPressed: () {
              // Accept functionality
            },
            child: Text("Accept"),
          ),
        ),
      ],
    );
  }
}
