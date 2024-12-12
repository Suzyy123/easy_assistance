import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestService {
  // Method to send a friend request
  Future<void> sendFriendRequest(String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    final currentUserId = currentUser.uid;
    final senderName = currentUser.displayName ?? 'Anonymous';
    final senderImageUrl = currentUser.photoURL ?? '';

    try {
      await FirebaseFirestore.instance.collection('friend_requests').add({
        'from': currentUserId,
        'to': receiverId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'senderName': senderName,
        'senderImageUrl': senderImageUrl,
      });
      print("Friend request sent successfully!");
    } catch (e) {
      print("Error sending friend request: $e");
    }
  }

  // Accept friend request
  Future<void> acceptRequest(String requestId, String fromUserId, String toUserId) async {
    try {
      // Update the friend request status to "accepted"
      await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).update({
        'status': 'accepted',
      });

      // Add to the "friends" collection
      await FirebaseFirestore.instance.collection('friends').add({
        'user1': fromUserId,
        'user2': toUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Friend request accepted for $fromUserId and $toUserId");
    } catch (e) {
      print("Error accepting friend request: $e");
    }
  }

  // Decline friend request
  Future<void> declineRequest(String requestId) async {
    try {
      // Delete the friend request upon rejection
      await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).delete();
      print("Friend request rejected and removed for request ID: $requestId");
    } catch (e) {
      print("Error declining friend request: $e");
    }
  }
}
