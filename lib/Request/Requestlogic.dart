import 'package:cloud_firestore/cloud_firestore.dart';

import 'FirendRequest.dart';

Future<void> sendFriendRequest(String senderId, String receiverId) async {
  try {
    var friendRequest = FriendRequest(
      senderId: senderId,
      receiverId: receiverId,
      status: 'pending',
    );

    await FirebaseFirestore.instance.collection('friend_requests').add(friendRequest.toJson());
    print("Friend request sent successfully.");
  } catch (e) {
    print("Error sending friend request: $e");
  }
}
