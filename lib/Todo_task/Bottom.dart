import 'package:flutter/material.dart';
import '../Pages/homePage.dart';
import 'Meeting_All/Meeting.dart';
import 'Notes_All/DocsPage.dart';
import 'Tasks_All/createPage.dart';

class bottomNavBar extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final Color color;

  const bottomNavBar({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
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
          color: color,
          size: 30,
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

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
            bottomNavBar(
              icon: Icons.home,
              color: Colors.white, // Set icon color to white
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
              bottomNavBar(
                icon: Icons.library_add,
                color: Colors.white,
                onTap: () {
                  // Add your navigation action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Create()),
                  );
                },
              ),
              bottomNavBar(
                icon: Icons.note_alt_sharp,
                color: Colors.white,
                onTap: () {
                  // Add your navigation action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  NotePage()),
                  );
                },
              ),
              bottomNavBar(
                icon: Icons.meeting_room_outlined,
                color: Colors.white,
                onTap: () {
                  // Add your navigation action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateMeetingPage()),
                  );
                },
              ),
              // bottomNavBar(
              //   icon: Icons.chat_sharp,
              //   color: Colors.white,
              //   onTap: () {
              //     // Add your navigation action here
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => const ChatPage()),
              //     );
              //   },
              // ),
              bottomNavBar(
                icon: Icons.library_add_check,
                color: Colors.white,
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) =>  TodoApp()),
                  // );

                },
              ),
          ],
        ),
      ),
    );
  }
}
