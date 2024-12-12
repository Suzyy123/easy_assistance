import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_assistance_app/ChatPage/ChatBubble.dart';
import 'package:easy_assistance_app/Components/textFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatfucntions.dart';

class Messenger extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveruserUsername;

  const Messenger({
    Key? key,
    required this.receiveruserEmail,
    required this.receiveruserUsername,
  }) : super(key: key);

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  final TextEditingController messageController = TextEditingController();
  final ChatFunction chatFunction = ChatFunction();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isChatDeleted = false; // Flag to check if the chat was deleted

  Future<void> deleteChat() async {
    try {
      String currentUserEmail = _firebaseAuth.currentUser!.email!;
      String chatDocId = getChatDocumentId(currentUserEmail, widget.receiveruserEmail);

      DocumentReference chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatDocId);

      // Check if the chat document exists
      DocumentSnapshot chatDocSnapshot = await chatDocRef.get();
      if (!chatDocSnapshot.exists) {
        print("Chat document does not exist.");
        return;
      }

      // Step 1: Delete all messages in the chat
      QuerySnapshot messagesSnapshot = await chatDocRef.collection('messages').get();
      for (var messageDoc in messagesSnapshot.docs) {
        await messageDoc.reference.delete();
      }

      // Step 2: Delete the chat document itself
      await chatDocRef.delete();
      print("Chat and all messages deleted successfully!");

      setState(() {
        // Update UI to reflect the chat deletion
        Navigator.of(context).pop(); // Navigate back after chat deletion
      });
    } catch (e) {
      print("Error deleting chat: $e");
    }
  }

  // Function to delete a specific message
  Future<void> deleteMessage(DocumentReference messageRef) async {
    try {
      await messageRef.delete();
      print("Message deleted successfully!");
      setState(() {}); // Update UI after deletion
    } catch (e) {
      print("Error deleting message: $e");
    }
  }

  // Function to send a message
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatFunction.sendMessage(widget.receiveruserEmail, messageController.text);
      messageController.clear();
      setState(() {});
    }
  }

  // Function to get username from email
  Future<String> getUsernameFromEmail(String email) async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        return userData['username'] ?? email;
      } else {
        return email;
      }
    } catch (e) {
      print("Error fetching username: $e");
      return email;
    }
  }

  // Helper function to get consistent chat document ID
  String getChatDocumentId(String user1, String user2) {
    List<String> users = [user1.trim().toLowerCase(), user2.trim().toLowerCase()];
    users.sort(); // Ensure consistent document ID
    return users.join("_");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Text(widget.receiveruserUsername),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showDeleteChatDialog();
            },
          ),
        ],
      ),
      body: isChatDeleted
          ? const Center(child: Text('Chat deleted successfully'))
          : Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // Build message list
  Widget buildMessageList() {
    if (isChatDeleted) {
      return const Center(child: Text('Chat deleted successfully'));
    }

    return StreamBuilder(
      stream: chatFunction.getMessages(widget.receiveruserEmail, _firebaseAuth.currentUser?.email ?? ""),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages yet'));
        }

        return ListView(
          children: snapshot.data!.docs.map((document) => buildMessageItem(document)).toList(),
        );
      },
    );
  }

  // Build individual message item
  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderEmail'] == _firebaseAuth.currentUser?.email) ? Alignment.centerRight : Alignment.centerLeft;

    return FutureBuilder<String>(
      future: getUsernameFromEmail(data['senderEmail']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.hasError) {
          return const Text('Error loading username');
        }

        String senderUsername = snapshot.data ?? 'Unknown User';
        if (data['senderEmail'] == _firebaseAuth.currentUser?.email) {
          senderUsername = "You";
        }

        return GestureDetector(
          onLongPress: () {
            if (data['senderEmail'] == _firebaseAuth.currentUser?.email) {
              _showDeleteDialog(document.reference);
            }
          },
          child: Container(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: alignment == Alignment.centerRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(senderUsername),
                  const SizedBox(height: 8),
                  chatBubble(message: data['message']),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build message input
  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              hintText: "Enter a message",
              obscureText: false,
              controller: messageController,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, size: 40),
          ),
        ],
      ),
    );
  }

  // Show delete chat confirmation dialog
  void _showDeleteChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Chat"),
          content: const Text("Are you sure you want to delete the entire chat?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await deleteChat();
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Show delete message confirmation dialog
  void _showDeleteDialog(DocumentReference messageRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Message"),
          content: const Text("Are you sure you want to delete this message?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await deleteMessage(messageRef);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
