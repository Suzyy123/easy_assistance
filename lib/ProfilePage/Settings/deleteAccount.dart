import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  Future<void> reauthenticateUser(String email, String password) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: password);

      // Re-authenticate the user
      await user?.reauthenticateWithCredential(credential);
      print('User re-authenticated successfully.');
    } catch (e) {
      print('Error during re-authentication: $e');
      throw Exception('Failed to re-authenticate. Please try again.');
    }
  }

  Future<void> deleteAccount(String userEmail) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final FirebaseAuth _auth = FirebaseAuth.instance;

      // Batch deletion for associated data
      Future<void> deleteCollection(String collectionName) async {
        print('Deleting from collection: $collectionName');
        final QuerySnapshot snapshot = await _firestore
            .collection(collectionName)
            .where('email', isEqualTo: userEmail)
            .get();

        for (DocumentSnapshot doc in snapshot.docs) {
          print('Deleting document: ${doc.id} from $collectionName');
          await doc.reference.delete();
        }
      }

      // Delete data from associated collections
      await deleteCollection('meetings');
      await deleteCollection('notes');
      await deleteCollection('taskLists');
      await deleteCollection('tasks');

      // Delete user profile (users collection)
      print('Deleting user profile...');
      final QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      for (DocumentSnapshot doc in userSnapshot.docs) {
        await doc.reference.delete();
      }
      print('User profile deleted successfully!');

      // Delete user authentication
      print('Deleting user from authentication...');
      final User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        throw Exception('No authenticated user found.');
      }
    } catch (e) {
      print('Error deleting account: $e');
      throw Exception('Failed to delete account. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    String password = '';

    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you want to delete your account? This action is irreversible.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
              onChanged: (value) {
                password = value; // Store the password
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final User? user = FirebaseAuth.instance.currentUser;
                  final String userEmail = user?.email ?? '';
                  if (userEmail.isEmpty) throw Exception('User email not found.');

                  // Step 1: Re-authenticate the user
                  await reauthenticateUser(userEmail, password);

                  // Step 2: Delete account
                  await deleteAccount(userEmail);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deleted successfully.')),
                  );

                  // Navigate to the login page and clear the navigation stack
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login', // Ensure '/login' is a valid named route in your app.
                        (route) => false, // Clears the navigation stack.
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Account'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
