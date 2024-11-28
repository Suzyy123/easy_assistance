import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> acceptFriendRequest(String requestId) async {
  try {
    await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).update({
      'status': 'accepted',
    });
    print("Friend request accepted.");
  } catch (e) {
    print("Error accepting friend request: $e");
  }
}

Future<void> rejectFriendRequest(String requestId) async {
  try {
    await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).update({
      'status': 'rejected',
    });
    print("Friend request rejected.");
  } catch (e) {
    print("Error rejecting friend request: $e");
  }
}
