import 'package:flutter/material.dart';
import 'homePage.dart';
// Ensure you import the correct Home Page file.

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  final List<Map<String, String>> friendRequests = [
    {
      "name": "John Doe",
      "description": "Software Engineer at Google",
      "imageUrl": "https://via.placeholder.com/150",
    },
    {
      "name": "Jane Smith",
      "description": "Product Manager at Amazon",
      "imageUrl": "https://via.placeholder.com/150",
    },
    {
      "name": "Mike Johnson",
      "description": "UI/UX Designer at Adobe",
      "imageUrl": "https://via.placeholder.com/150",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const homePage()),
            );
          },
        ),
        title: const Text(
          "Friend Requests",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: friendRequests.length,
            itemBuilder: (context, index) {
              final request = friendRequests[index];
              return FriendRequestCard(
                name: request["name"]!,
                description: request["description"]!,
                imageUrl: request["imageUrl"]!,
                onDelete: () {
                  setState(() {
                    friendRequests.removeAt(index);
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class FriendRequestCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback onDelete;

  const FriendRequestCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add accept action here if needed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Confirm"),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onDelete,
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
