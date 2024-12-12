import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to view friend requests.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Requests"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('friend_requests')
            .where('toEmail', isEqualTo: currentUser.email) // Query for requests to the current user
            .where('status', isEqualTo: 'pending') // Only fetch pending requests
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final requests = snapshot.data?.docs;

          if (requests == null || requests.isEmpty) {
            return const Center(child: Text("No friend requests found."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final fromUsername = request['fromUsername'] ?? 'Unknown User';
              final fromEmail = request['fromEmail'] ?? 'Unknown Email';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(fromUsername),
                  subtitle: Text(fromEmail),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await _acceptRequest(request.id, fromEmail);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await _declineRequest(request.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _acceptRequest(String requestId, String fromEmail) async {
    try {
      // Update the status of the request to accepted
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .update({'status': 'accepted'});

      // Optionally, add to a "friends" collection
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('friends').add({
          'user1': currentUser.email,
          'user2': fromEmail,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Friend request accepted.")),
      );
    } catch (e) {
      print('Error accepting friend request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _declineRequest(String requestId) async {
    try {
      // Delete the request
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Friend request declined.")),
      );
    } catch (e) {
      print('Error declining friend request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
