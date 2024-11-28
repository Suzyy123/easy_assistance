import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvatarSelectionPage extends StatefulWidget {
  const AvatarSelectionPage({super.key});

  @override
  State<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  final List<String> avatars = [
    'lib/images/avatar1.png',
    'lib/images/avatar2.png',
    'lib/images/avatar3.png',
    'lib/images/avatar4.png',
    'lib/images/avatar5.png',
    'lib/images/avatar6.png',
    'lib/images/avatar7.png',
    'lib/images/avatar8.png',
  ];

  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _loadSelectedAvatar();
  }

  Future<void> _loadSelectedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    String? avatarUrl = prefs.getString('selectedAvatar'); // Load selected avatar locally

    // Load from backend if not available locally
    if (avatarUrl == null) {
      avatarUrl = await _loadSelectedAvatarFromBackend("USER_ID"); // Replace "USER_ID" with actual user ID
    }

    setState(() {
      selectedAvatar = avatarUrl;
    });
  }

  Future<String?> _loadSelectedAvatarFromBackend(String userId) async {
    final String serverUrl = "http://your-backend-server-address/getAvatar/$userId";

    try {
      final response = await http.get(Uri.parse(serverUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['avatarUrl'];
      } else {
        print("Failed to fetch avatar from backend");
        return null;
      }
    } catch (e) {
      print("Error fetching avatar from backend: $e");
      return null;
    }
  }

  Future<void> _saveSelectedAvatar(String avatarPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatarPath); // Save selected avatar locally

    // Save to backend database
    await _saveSelectedAvatarToBackend(avatarPath);

    setState(() {
      selectedAvatar = avatarPath;
    });
  }

  Future<void> _saveSelectedAvatarToBackend(String avatarPath) async {
    const String userId = "USER_ID"; // Replace with the actual user ID
    final String serverUrl = "http://your-backend-server-address/updateAvatar";

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId, "avatarUrl": avatarPath}),
      );

      if (response.statusCode == 200) {
        print("Avatar updated successfully in the backend");
      } else {
        print("Failed to update avatar in the backend");
      }
    } catch (e) {
      print("Error updating avatar in the backend: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Avatar"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of avatars in a row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatarPath = avatars[index];
          return GestureDetector(
            onTap: () => _saveSelectedAvatar(avatarPath),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedAvatar == avatarPath
                      ? Colors.blue
                      : Colors.transparent,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  avatarPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 40, color: Colors.red);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
