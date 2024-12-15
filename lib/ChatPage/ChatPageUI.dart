import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/icons.dart';
import '../ChatPage/Messenger.dart';
import '../authServices/AuthGate.dart';
import '../services/friendsService.dart';
import 'Searchfucntion.dart';
import 'chatListPage.dart';
import 'friendRequestPage.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? profileAvatar;
  String searchQuery = "";
  List<Map<String, dynamic>> searchResults = [];
  final UserSearchService _userSearchService = UserSearchService();

  @override
  void initState() {
    super.initState();
    _loadProfileAvatar();
  }

  Future<void> _loadProfileAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileAvatar = prefs.getString('selectedAvatar') ?? 'lib/images/default_avatar.png';
    });
  }

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
        backgroundColor: Colors.blue[800],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage: profileAvatar != null
                ? AssetImage(profileAvatar!)
                : const AssetImage('lib/images/avatar2.png'),
          ),
        ),
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextStyle(color: Colors.white), // Loading text in white
              );
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text(
                "Unknown User",
                style: TextStyle(color: Colors.white), // Unknown user text in white
              );
            }
            final userData = snapshot.data!;
            return Text(
              userData['username'] ?? 'No Username',
              style: const TextStyle(
                color: Colors.white,

              ),
            );
          },
        ),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by username or email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
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
          if (searchQuery.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    "Messages",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FriendRequestPage()),
                      );
                    },
                    child: const Text(
                      "Requests",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          if (searchQuery.isNotEmpty)
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Search Results",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Expanded(
            child: searchQuery.isNotEmpty && searchResults.isNotEmpty
                ? ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final user = searchResults[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
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
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          await _sendFriendRequest(user);
                        },
                        child: const Text('Request'),
                      ),
                    ],
                  ),
                );
              },
            )
                : searchQuery.isNotEmpty && searchResults.isEmpty
                ? const Center(child: Text("No friends"))
                : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Expanded(
                  child: FriendLists(), // Call FriendList here
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }

  Future<void> _sendFriendRequest(Map<String, dynamic> user) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _showDialog("Not Logged In", "You need to log in first to send a friend request.");
      return;
    }

    final fromEmail = currentUser.email;
    final fromUserId = currentUser.uid;

    // Fetch the current user's username from the Firestore `users` collection
    final fromUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(fromUserId)
        .get();
    final fromUsername = fromUserSnapshot.data()?['username'] ?? 'Unknown User';

    final toEmail = user['email'];
    final toUserId = user['id']; // Make sure the `user` map contains the recipient's user ID
    final toUsername = user['username'];

    if (fromEmail == toEmail) {
      _showDialog("Invalid Request", "You cannot send a friend request to yourself.");
      return;
    }

    try {
      // Check if a request already exists between the two users
      final existingRequest = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('fromEmail', isEqualTo: fromEmail)
          .where('toEmail', isEqualTo: toEmail)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        _showDialog("Already Sent", "You have already sent a friend request to this user.");
        return;
      }

      // Save the friend request with all required information
      await FirebaseFirestore.instance.collection('friend_requests').add({
        'fromEmail': fromEmail,
        'fromUsername': fromUsername,
        'fromUserId': fromUserId,
        'toEmail': toEmail,
        'toUsername': toUsername,
        'toUserId': toUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showDialog("Success", "Friend request sent successfully!");
    } catch (e) {
      _showDialog("Error", "Failed to send friend request: $e");
    }
  }


  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
