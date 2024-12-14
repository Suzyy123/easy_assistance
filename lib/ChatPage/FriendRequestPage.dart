import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/FriendRequestService.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  List<Map<String, dynamic>> friendRequests = [];

  @override
  void initState() {
    super.initState();
    _loadFriendRequests();
  }

  // Load the friend requests for the receiver (current user)
  void _loadFriendRequests() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      print("User not logged in");
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('to', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      setState(() {
        friendRequests = snapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "from": doc['from'],
            "name": doc['from'],  // Use the sender's user ID for now
            "imageUrl": null, // No profileImageUrl in the users collection, so set as null
          };
        }).toList();
      });
    } catch (e) {
      print("Error loading friend requests: $e");
    }
  }

  // Accept friend request
  void acceptRequest(String requestId, String fromUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      print("User not logged in");
      return;
    }

    try {
      // Update the status of the friend request to "accepted"
      await FriendRequestService().acceptRequest(requestId, fromUserId, currentUserId);

      // After updating the status, manually reload the friend requests
      _loadFriendRequests();

      // Optionally, you can remove the accepted request from the current list immediately
      setState(() {
        friendRequests.removeWhere((request) => request['id'] == requestId);
      });
    } catch (e) {
      print("Error accepting friend request: $e");
    }
  }

  // Decline friend request
  void declineRequest(String requestId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      print("User not logged in");
      return;
    }

    try {
      // Update the status of the friend request to "rejected"
      await FriendRequestService().declineRequest(requestId);

      // After updating the status, manually reload the friend requests
      _loadFriendRequests();

      // Optionally, you can remove the declined request from the current list immediately
      setState(() {
        friendRequests.removeWhere((request) => request['id'] == requestId);
      });
    } catch (e) {
      print("Error declining friend request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Friend Requests"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: friendRequests.isEmpty
          ? const Center(child: Text("No friend requests"))
          : ListView.builder(
        itemCount: friendRequests.length,
        itemBuilder: (context, index) {
          final request = friendRequests[index];
          return FriendRequestCard(
            name: request['name'],
            imageUrl: request['imageUrl'], // Null or empty URL will trigger the default image
            onAccept: () => acceptRequest(request['id'], request['from']),
            onDelete: () => declineRequest(request['id']),
          );
        },
      ),
    );
  }
}

class FriendRequestCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback onAccept;
  final VoidCallback onDelete;

  const FriendRequestCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onAccept,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : const AssetImage('lib/images/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Accept"),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onDelete,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Decline"),
            ),
          ],
        ),
      ),
    );
  }
}
