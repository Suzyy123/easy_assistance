import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Message.dart';

class ChatFunction {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter for the current user's email
  String? get currentUserEmail {
    return _firebaseAuth.currentUser?.email;
  }

  // Send message function
  Future<void> sendMessage(String receiverEmail, String message) async {
    // Get current user info
    final String? currentUserEmail = _firebaseAuth.currentUser?.email;

    if (currentUserEmail == null) {
      return; // Exit if no user is logged in
    }

    final Timestamp timestamp = Timestamp.now();

    // Create new message
    Message newMessage = Message(
      senderEmail: currentUserEmail,
      receiverEmail: receiverEmail,
      message: message,
      timestamp: timestamp,
    );
    List<String> ids = [currentUserEmail, receiverEmail];
    ids.sort(); // Ensure chat room ids are consistent for the same users
    String chatRoomId = ids.join("_"); // Create chat room id by joining ids into a single string to use as a chatroom

    // Adding message to Firestore
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Get messages function
  Stream<QuerySnapshot> getMessages(String userEmail, String userEmail2) {
    List<String> ids = [userEmail, userEmail2];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
