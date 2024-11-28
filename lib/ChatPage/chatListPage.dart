import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ProfilePage/AvatarSelectionPage.dart';
import 'messenger.dart'; // Replace with the correct import for the Messenger page

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading users.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        // Build the user list with separate containers
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: snapshot.data!.docs
              .map((doc) => buildUserContainer(context, doc))
              .toList(),
        );
      },
    );
  }

  // Function to build individual user containers
  Widget buildUserContainer(BuildContext context, DocumentSnapshot document) {
    // Safely cast the document to Map
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    // If the document data is null, return an empty container
    if (data == null) {
      return Container();
    }

    // Get the current logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;

    // If no user is logged in, avoid building the list
    if (currentUser == null) {
      return Container();
    }

    // Exclude the current user from the list
    if (currentUser.email != data['email']) {
      // Check if email, username, and avatarUrl fields are present
      final email = data['email'];
      final username = data['username'];
      final avatarUrl = data['avatarUrl']; // Get avatarUrl if it exists

      if (email != null && username != null) {
        return GestureDetector(
          onTap: () {
            // Navigate to the Messenger page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Messenger(
                  receiveruserEmail: email,
                  receiveruserUsername: username,
                ),
              ),
            );
          },
          child: Container(
            height: 80,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF013763), // Purple background color
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: [
                // Avatar Circle on the Left
                CircleAvatar(
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl) // Display user avatar if available
                      : null, // No default avatar
                  radius: 24, // Avatar size
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.white) // Placeholder icon if no avatar is set
                      : null,
                ),
                const SizedBox(width: 16),
                // User Info (Username and Email)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Add an optional icon if you want a button on the right side
                IconButton(
                  icon: Icon(
                    Icons.more_vert,  // Vertical three dots
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                )
              ],
            ),
          ),
        );
      }
    }

    return Container(); // Return an empty container for any invalid or excluded data
  }
}
