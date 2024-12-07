import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Re-authenticate user
  Future<void> reauthenticateUser(String email, String password) async {
    User? user = _auth.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user?.reauthenticateWithCredential(credential);
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.updateEmail(newEmail);
        await user.sendEmailVerification();
        print("Email updated successfully and verification email sent.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email updated! Verify your new email.")),
        );
      }
    } catch (e) {
      print("Error updating email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Handle email change
  Future<void> handleChangeEmail() async {
    setState(() {
      isLoading = true;
    });

    String currentEmail = currentEmailController.text.trim();
    String password = passwordController.text.trim();
    String newEmail = newEmailController.text.trim();

    try {
      // Step 1: Reauthenticate
      await reauthenticateUser(currentEmail, password);

      // Step 2: Update Email
      await updateEmail(newEmail);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Email")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: currentEmailController,
              decoration: InputDecoration(labelText: "Current Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: newEmailController,
              decoration: InputDecoration(labelText: "New Email"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: handleChangeEmail,
              child: Text("Change Email"),
            ),
          ],
        ),
      ),
    );
  }
}
