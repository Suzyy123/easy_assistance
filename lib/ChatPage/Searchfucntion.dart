import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchService {
  // Function to handle searching users by username or email
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      // Convert query to lowercase for case-insensitive matching
      String lowerQuery = query.toLowerCase();

      // Perform prefix-based search using startAt and endAt
      QuerySnapshot<Map<String, dynamic>> usersByUsername = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('username')
          .startAt([lowerQuery])
          .endAt([lowerQuery + '\uf8ff'])
          .get();

      QuerySnapshot<Map<String, dynamic>> usersByEmail = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('email')
          .startAt([lowerQuery])
          .endAt([lowerQuery + '\uf8ff'])
          .get();

      // Combine results from both username and email search
      List<Map<String, dynamic>> combinedResults = [
        ...usersByUsername.docs.map((doc) => doc.data()),
        ...usersByEmail.docs.map((doc) => doc.data())
      ];

      return combinedResults;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }
}
