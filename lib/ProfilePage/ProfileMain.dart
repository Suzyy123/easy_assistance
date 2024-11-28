import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/icons.dart';
import '../Components/textFields.dart';
import '../Components/buttons.dart';
import '../authServices/AuthServices.dart';
import 'ProfileChangingPage.dart'; // Ensure this is the correct import path


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void logoutfrompage() {
    final auth = AuthServices();
    auth.signOut();
  }

  // Loading user details
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Retrieve user data from Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          usernameController.text = userData['username'] ?? '';
          emailController.text = user.email ?? '';
        });

        // Retrieve avatar from local storage
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          selectedAvatar =
              prefs.getString('selectedAvatar') ?? 'lib/images/logo.png';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Updating username in firebase
  Future<void> _updateUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'username': usernameController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Save selected avatar locally
  Future<void> _saveSelectedAvatar(String avatarPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatarPath);
    setState(() {
      selectedAvatar = avatarPath;
    });
  }

  // Navigate to avatar selection page and update avatar
  Future<void> _selectAvatar() async {
    final selectedAvatarPath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const Profilechangingpage()),
    );
    if (selectedAvatarPath != null) {
      await _saveSelectedAvatar(selectedAvatarPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: logoutfrompage,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0), // Added padding at the bottom
          child: Column(
            children: [
              // Profile Changing Widget
              GestureDetector(
                onTap: _selectAvatar,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: selectedAvatar != null
                      ? AssetImage(selectedAvatar!)
                      : const AssetImage('lib/images/avatar1.png'),
                ),
              ),
              const SizedBox(height: 20),

              // Username Field
              MyTextfield(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 20),

              // Email Field (Read-only)
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 20),

              // Update Username Button
              Buttons(
                text: "Update ",
                onTap: _updateUsername,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavigatorBar(), // Corrected placement of NavigatorBar
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
