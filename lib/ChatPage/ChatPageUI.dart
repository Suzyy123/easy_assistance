import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/icons.dart';
import '../authServices/AuthServices.dart';
import 'Searchfucntion.dart';
import 'chatListPage.dart';
import 'chatfucntions.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? profileAvatar;
  String searchQuery = "";
  List<Map<String, dynamic>> searchResults = [];

  final UserSearchService _userSearchService = UserSearchService(); // Instance of UserSearchService

  @override
  void initState() {
    super.initState();
    _loadProfileAvatar();
  }

  // Log out the user
  void logoutfrompage() async {
    final auth = AuthServices();
    await auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // Replace with your actual route
  }

  // Load avatar from SharedPreferences
  Future<void> _loadProfileAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileAvatar = prefs.getString('selectedAvatar') ?? 'lib/images/default_avatar.png';
    });
  }

  // Function to handle searching users by username or email
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      List<Map<String, dynamic>> results = await _userSearchService.searchUsers(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error searching users: $e');
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage: profileAvatar != null
                ? AssetImage(profileAvatar!)
                : const AssetImage('lib/images/logo.png'),
          ),
        ),
        title: const Text("Chat Page"),
        actions: [
          IconButton(
            onPressed: logoutfrompage,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Container
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search by username or email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          suffixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                          searchUsers(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Messages and Requests Header - Only show if searchQuery is empty
                if (searchQuery.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: const [
                        Text(
                          "Messages",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(), // This will push "Requests" to the right
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Requests",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Display Search Results label
                if (searchQuery.isNotEmpty)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Search Results",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),

          // Search Results or Main Content
          Expanded(
            child: searchQuery.isNotEmpty && searchResults.isNotEmpty
                ? ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final user = searchResults[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.pink, // Purple background color
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: user['avatarUrl'] != null
                            ? NetworkImage(user['avatarUrl'])
                            : const AssetImage('lib/images/default_avatar.png') as ImageProvider,
                        radius: 24,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['username'] ?? 'No Username',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user['email'] ?? 'No Email',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
                : searchQuery.isNotEmpty && searchResults.isEmpty
                ? const Center(child: Text("No users found"))
                : const ChatList(),
          ),

          // Bottom Navigation Bar
          const NavigatorBar(),
        ],
      ),
    );
  }
}
