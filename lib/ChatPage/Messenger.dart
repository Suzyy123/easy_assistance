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
    super.key,
    required this.receiveruserEmail,
    required this.receiveruserUsername,
  });

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  final TextEditingController messageController = TextEditingController();
  final ChatFunction chatFunction = ChatFunction();

  // instance of the auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatFunction.sendMessage(
          widget.receiveruserEmail, messageController.text);
      // clear controller after sending the message
      messageController.clear();
    }
  }

  // Function to get username from email
  Future<String> getUsernameFromEmail(String email) async {
    try {
      var userSnapshot = await FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: email).limit(1)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        return userData['username'] ??
            email; // Return username or email if no username found
      } else {
        return email; // Return email if no user found
      }
    } catch (e) {
      print("Error fetching username: $e");
      return email; // Return email in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Text(widget.receiveruserUsername, style:
          TextStyle(color: Colors.white),),
        ),
        backgroundColor: Color(0xFF013763),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white,), // Corrected icon
            onPressed: () {
              // You can add functionality here if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          // user input
          buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // build message list
  Widget buildMessageList() {
    return StreamBuilder(
      stream: chatFunction.getMessages(
          widget.receiveruserEmail, _firebaseAuth.currentUser!.email!),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No messages yet');
        }
        // Displaying the list of messages using buildMessageItem()
        return ListView(
          children: snapshot.data!.docs.map((document) =>
              buildMessageItem(document)).toList(),
        );
      },
    );
  }

  // build message item
  Widget buildMessageItem(DocumentSnapshot document) {
    // Create a map from the Firestore document snapshot
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Align the message to the right if the sender is the current user
    var alignment = (data['senderEmail'] == _firebaseAuth.currentUser!.email)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Fetch username for the sender email
    return FutureBuilder<String>(
      future: getUsernameFromEmail(data['senderEmail']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading"); // Loading indicator until username is fetched
        }
        if (snapshot.hasError) {
          return const Text('Error loading username');
        }

        // Check if the sender is the current user
        String senderUsername = snapshot.data ?? 'Unknown User';
        if (data['senderEmail'] == _firebaseAuth.currentUser!.email) {
          senderUsername = "You"; // Display "You" for the current user
        }

        return Container(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: (data['senderEmail'] ==
                  _firebaseAuth.currentUser!.email)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisAlignment: (data['senderEmail'] ==
                  _firebaseAuth.currentUser!.email)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                // Show the sender username
                Text(senderUsername),
                const SizedBox(height: 8),
                // Show the message content
                chatBubble(message: data['message']),
              ],
            ),
          ),
        );
      },
    );
  }

  // build message input
  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: messageController,
        decoration: InputDecoration(
          hintText: "Enter a message",
          hintStyle: TextStyle(color: Colors.grey[400]),
          // Hint text color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            borderSide: BorderSide(color: Color(0xFF013763)), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Color(0xFF013763), width: 2), // Focus border color and width
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors.blueGrey), // Enabled border color
          ),
          filled: true,
          // Fill the background
          fillColor: Colors.grey[300],
          // Background color
          suffixIcon: IconButton(
            onPressed: sendMessage, // Action for the upward arrow
            icon: Icon(
              Icons.arrow_upward,
              size: 30, // Size of the icon
              color: Color(0xFF013763), // Icon color
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15, // Adjust vertical padding inside the TextField
            horizontal: 10, // Adjust horizontal padding inside the TextField
          ),
        ),
        style: TextStyle(color: Colors.black), // Text input color
      ),
    );
  }
}