import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestService {
  // Method to send a friend request
  Future<void> sendFriendRequest(String receiverId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw Exception("User not logged in");
    }

    try {
      await FirebaseFirestore.instance.collection('friend_requests').add({
        'from': currentUserId,
        'to': receiverId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'senderName': 'User Name', // Set the sender's name
        'senderImageUrl': 'Image URL', // Set the sender's image URL
      });
    } catch (e) {
      print("Error sending friend request: $e");
    }
  }

  // Accept friend request
  Future<void> acceptRequest(String requestId, String fromUserId, String toUserId) async {
    try {
      // Update the friend request status to "accepted"
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .update({
        'status': 'accepted', // Update the status field to "accepted"
      });

      // Optionally, you can add code to create a friend document in another collection if needed
      // (e.g., "friends" collection where the user pair is added as friends).

      print("Friend request accepted for $fromUserId and $toUserId");
    } catch (e) {
      print("Error accepting friend request: $e");
    }
  }

  // Decline friend request
  Future<void> declineRequest(String requestId) async {
    try {
      // Update the friend request status to "rejected"
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .update({
        'status': 'rejected', // Update the status field to the "rejected"
      });

      print("Friend request rejected for request ID: $requestId");
    } catch (e) {
      print("Error declining friend request: $e");
    }
  }
}
