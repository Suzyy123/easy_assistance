import 'package:flutter/material.dart';
import '../ChatPage/ChatPageUI.dart';
import '../ProfilePage/ProfileMain.dart';
import '../RegisterPages/homePage.dart';

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
        padding: const EdgeInsets.all(10),
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
      color: Color(0xFF013763), // Background color of the navigation bar
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10), // Add padding to adjust height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavigationBarButton(
              icon: Icons.home,
              color: Colors.white, // Set icon color to white
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
            ),
            NavigationBarButton(
              icon: Icons.calendar_month,
              color: Colors.white, // Set icon color to white
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
            ),
            NavigationBarButton(
              icon: Icons.messenger,
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
