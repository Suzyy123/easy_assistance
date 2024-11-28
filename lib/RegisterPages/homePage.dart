import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_assistance_app/ChatPage/Messenger.dart';
import 'package:easy_assistance_app/authServices/AuthServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/icons.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Instance of FirebaseAuth
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Logout function
  void logoutfrompage() {
    final auth = AuthServices();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: _showUserList(),
      // bottomNavigationBar: const NavigatorBar(),
    );
  }

  // Function to show user list
  Widget _showUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(), // Listening to the users collection
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading spinner when waiting
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        // Return list view after data is fetched
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => buildUserList(doc)).toList(),
        );
      },
    );
  }

  // Individual user list items
  Widget buildUserList(DocumentSnapshot document) {
    // Safely cast the document to Map
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    // If the document data is null, return an empty container
    if (data == null) {
      return Container();
    }

    // Check if auth.currentUser is null
    if (auth.currentUser == null) {
      return Container(); // If no user is logged in, avoid building the list
    }

    // All users except the current user
    if (auth.currentUser!.email != data['email']) {
      // Check if email and username fields are present
      final email = data['email'];
      final username = data['username'];
      if (email != null && username != null) {
        return ListTile(
          title: Text(email),
          onTap: () {
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
        );
      } else {
        return Container(); // Return an empty container if fields are missing
      }
    } else {
      return Container(); // Return an empty container for the current user to avoid null issues
    }
  }
}
