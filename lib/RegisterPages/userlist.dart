import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_assistance_app/ChatPage/Messenger.dart';
import 'package:easy_assistance_app/authServices/AuthServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/icons.dart';

class userList extends StatefulWidget {
  const userList({super.key});

  @override
  State<userList> createState() => _HomepageState();
}

class _HomepageState extends State<userList> {
  // Instance of FirebaseAuth
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Logout function
  void logoutfrompage() {
    final auth = AuthServices();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: _showFriendsList(), // Displays the list of friends
      bottomNavigationBar: const NavigatorBar(), // Correct usage of bottomNavigationBar
    );
  }


  // Function to show friends list
  Widget _showFriendsList() {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text("Please log in to see your friends."),
      );
    }

    // Query to get only accepted friend requests where the current user is involved
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('friend_requests')
          .where('status', isEqualTo: 'accepted')
          .where('toEmail', isEqualTo: currentUser.email) // Requests accepted by the current user
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading friend requests.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No friends found.'));
        }

        final friendRequests = snapshot.data!.docs;

        // Fetch details of accepted friends
        return ListView(
          children: friendRequests.map<Widget>((doc) => buildFriendList(doc)).toList(),
        );
      },
    );
  }

  // Individual friend list items
  Widget buildFriendList(DocumentSnapshot document) {
    // Safely cast the document to Map
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    // If the document data is null, return an empty container
    if (data == null) {
      return Container();
    }

    final friendEmail = data['fromEmail'];
    final friendUsername = data['fromUsername'];

    if (friendEmail != null && friendUsername != null) {
      return ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(friendUsername),
        subtitle: Text(friendEmail),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Messenger(
                receiveruserEmail: friendEmail,
                receiveruserUsername: friendUsername,
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Return an empty container if fields are missing
    }

  }
}
