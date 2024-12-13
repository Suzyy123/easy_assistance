import 'package:flutter/material.dart';
import '../ChatPage/ChatPageUI.dart';
import '../Pages/homePage.dart';
import '../ProfilePage/ProfileMain.dart';
import '../RegisterPages/userlist.dart';
import '../Todo_task/frontPage.dart';

class NavigationBarButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final Color color; // Added color parameter

  const NavigationBarButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color, // Make color required to set icon color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 2, bottom: 6),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,

        ),
        child: Icon(
          icon,
          color: color, // Use the provided color
          size: 30, // Adjust icon size
        ),
      ),
    );
  }
}

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue[900], // Background color of the navigation bar
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2), // Add padding to adjust height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavigationBarButton(
              icon: Icons.home,
              color: Colors.white, // Set icon color to white
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            NavigationBarButton(
              icon: Icons.library_add_check,
              color: Colors.white, // Set icon color to white
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TodoApp()),
                );
              },
            ),
            NavigationBarButton(
              icon: Icons.mark_unread_chat_alt_rounded,
              color: Colors.white, // Set icon color to white
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
            ),
            NavigationBarButton(
              icon: Icons.person,
              color: Colors.white, // Set icon color to white
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
