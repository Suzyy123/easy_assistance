import 'package:flutter/material.dart';

import '../../ChatPage/ChatPageUI.dart';
import '../../Components/icons.dart';
import 'ChangeEmail.dart';
import 'OTPpage.dart';
import 'deleteAccount.dart';

class profileSettings extends StatelessWidget {
  const profileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Settings'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.mode),
              title: const Text('Dark Mode'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendAndVerifyOTPPage(), // Replace ChatPage with the actual destination page.
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendAndVerifyOTPPage(), // Replace ChatPage with the actual destination page.
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.domain_verification),
              title: const Text('Two-step verification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(), // Replace ChatPage with the actual destination page.
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Change Email'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailScreen(), // Replace ChatPage with the actual destination page.
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Review and Ratings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(), // Replace ChatPage with the actual destination page.
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('Buy Premiums'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(), // Replace ChatPage with the actual destination page.
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteAccountPage(), // Navigate to the delete account page.
                  ),
                );
              },
            ),

          ],
        ),
      ),
    bottomNavigationBar: SizedBox(
        height: 60,
        child: NavigatorBar(),
      ),
    );

  }
}
