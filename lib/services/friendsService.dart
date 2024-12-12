import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ChatPage/Messenger.dart';

class FriendLists extends StatelessWidget {
  const FriendLists({Key? key}) : super(key: key);

  Stream<List<DocumentSnapshot>> _getAcceptedFriendsStream() async* {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      yield [];
      return;
    }

    final toEmailQuery = FirebaseFirestore.instance
        .collection('friend_requests')
        .where('status', isEqualTo: 'accepted')
        .where('toEmail', isEqualTo: currentUser.email);

    final fromEmailQuery = FirebaseFirestore.instance
        .collection('friend_requests')
        .where('status', isEqualTo: 'accepted')
        .where('fromEmail', isEqualTo: currentUser.email);

    final toEmailSnapshot = await toEmailQuery.get();
    final fromEmailSnapshot = await fromEmailQuery.get();

    yield [
      ...toEmailSnapshot.docs,
      ...fromEmailSnapshot.docs,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _getAcceptedFriendsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No friends found."));
        }

        final friends = snapshot.data!;

        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index].data() as Map<String, dynamic>;
            final friendEmail = friend['fromEmail'] == FirebaseAuth.instance.currentUser!.email
                ? friend['toEmail']
                : friend['fromEmail'];
            final friendUsername = friend['fromEmail'] == FirebaseAuth.instance.currentUser!.email
                ? friend['toUsername']
                : friend['fromUsername'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Messenger(
                      receiveruserEmail: friendEmail,
                      receiveruserUsername: friendUsername,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.white54,
                  ),
                  title: Text(
                    friendUsername ?? 'Unknown User',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    friendEmail,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
