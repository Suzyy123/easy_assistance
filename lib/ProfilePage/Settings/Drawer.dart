import 'package:easy_assistance_app/ProfilePage/Settings/settingPage.dart';
import 'package:flutter/material.dart';

import '../../ChatPage/ChatPageUI.dart';
import '../../RegisterPages/loginPage.dart';
import '../../authServices/AuthGate.dart';
import '../../authServices/AuthServices.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/images/default_avatar.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome, User!', // Replace 'User' with a dynamic username
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Schedule'),
                  onTap: () {
                    Navigator.pushNamed(context, '/schedule');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.task),
                  title: const Text('Tasks'),
                  onTap: () {
                    Navigator.pushNamed(context, '/tasks');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.recommend),
                  title: const Text('Recommendations'),
                  onTap: () {
                    Navigator.pushNamed(context, '/recommendations');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Messaging'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(), // Replace ChatPage with the actual class for your settings page if needed
                      ),
                    );
                  },
                ),
                const Divider(), // Separator
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => profileSettings(), // Replace ChatPage with the actual class for your settings page if needed
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  onTap: () {
                    Navigator.pushNamed(context, '/help');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    try {
                      // Call the logout method from AuthServices
                      await AuthServices().signOut();

                      // Navigate to LoginPage directly
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Authgate()), // Replace LoginPage with your actual login page class
                      );

                      print('Logged out successfully');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed: $e')),
                      );
                    }
                  },
                ),



              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Replace with your actual logout function
    print('User logged out');
    Navigator.pushReplacementNamed(context, '/Loginpage'); // Navigate to login screen after logout
  }
}
