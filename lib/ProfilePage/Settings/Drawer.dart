import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_assistance_app/Pages/homePage.dart';
import 'package:easy_assistance_app/ProfilePage/Settings/settingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ChatPage/ChatPageUI.dart';
import '../../RegisterPages/loginPage.dart';
import '../../Todo_task/Meeting_All/MeetingPage.dart';
import '../../Todo_task/Tasks_All/TaskListPage.dart';
import '../../Todo_task/premium.dart';
import '../../authServices/AuthGate.dart';
import '../../authServices/AuthServices.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<DocumentSnapshot?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return FirebaseFirestore.instance.collection('users').doc(uid).get();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FutureBuilder<DocumentSnapshot?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DrawerHeader(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              String username = 'User';
              if (snapshot.hasData && snapshot.data?.exists == true) {
                final userData = snapshot.data?.data() as Map<String, dynamic>?;
                username = userData?['username'] ?? 'User';
              }

              return DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('lib/images/avatar2.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome, $username!',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())
                   );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Meetings'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingsPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.task),
                  title: const Text('Tasks'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskListPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.recommend),
                  title: const Text('Recommendations'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Messaging'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(),
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
                        builder: (context) => profileSettings(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    try {
                      await AuthServices().signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Authgate()),
                      );
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
}
