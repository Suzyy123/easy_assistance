import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> resetPassword(BuildContext context, String newPassword) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        // Update the password for the currently logged-in user
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully!')),
        );

        // Navigate back to the previous page or logout as needed
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Enter new password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Confirm new password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String password = passwordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();

                if (password.isEmpty || confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Both fields are required')),
                  );
                  return;
                }

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                // Reset password
                await resetPassword(context, password);
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
