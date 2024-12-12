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
    // Set placeholder text while loading
    usernameController.text = 'Loading...';
    emailController.text = 'Loading...';
    _loadUserData();
  }

  // Logging out the user
  void logoutfrompage() {
    final auth = AuthServices();
    auth.signOut();
  }

  // Loading user details
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('No user currently signed in.');
        return;
      }

      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (!userData.exists) {
        print('User document does not exist.');
        return;
      }

      // Debugging: Print loaded user data
      print('Loaded User Data: ${userData.data()}');

      // Update TextEditingController values directly
      setState(() {
        usernameController.text = userData.data()?['username'] ?? 'Default Username';
        emailController.text = user.email ?? 'No Email';
      });

      // Retrieve avatar from local storage
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        selectedAvatar = prefs.getString('selectedAvatar') ?? 'lib/images/default_avatar.png';
      });
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  // Updating username in Firebase
  Future<void> _updateUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': usernameController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Save selected avatar locally
  Future<void> _saveSelectedAvatar(String avatarPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedAvatar', avatarPath);
      setState(() {
        selectedAvatar = avatarPath;
      });
    } catch (e) {
      print('Error saving avatar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving avatar: $e')),
      );
    }
  }

  // Navigate to avatar selection page and update avatar
  Future<void> _selectAvatar() async {
    try {
      final selectedAvatarPath = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const Profilechangingpage()),
      );
      if (selectedAvatarPath != null) {
        await _saveSelectedAvatar(selectedAvatarPath);
      }
    } catch (e) {
      print('Error selecting avatar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting avatar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                          : const AssetImage('lib/images/default_avatar.png'),
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
                    text: "Update",
                    onTap: _updateUsername,
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: NavigatorBar(), // Add the NavigatorBar here
            ),
          ],
        ),
      ),
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
