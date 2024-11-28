import 'package:flutter/material.dart';

import '../authServices/AuthServices.dart';

class Profilechangingpage extends StatelessWidget {
  const Profilechangingpage({super.key});



  @override
  Widget build(BuildContext context) {
    final avatars = [
      'lib/images/avatar1.png',
      'lib/images/avatar2.png',
      'lib/images/avatar3.png',
      'lib/images/avatar4.png',
      'lib/images/avatar5.png',
      'lib/images/avatar6.png',
      'lib/images/avatar7.png',
      'lib/images/avatar8.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Avatar"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of avatars per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Return selected avatar path to previous screen
              Navigator.pop(context, avatars[index]);
            },
            child: CircleAvatar(
              backgroundImage: AssetImage(avatars[index]),
              radius: 50,
              backgroundColor: Colors.grey[300], // Placeholder background
              onBackgroundImageError: (error, stackTrace) {
                // Error handling for missing or invalid images
                print("Error loading image: $error");
              },
            ),
          );
        },
      ),
    );
  }
}
