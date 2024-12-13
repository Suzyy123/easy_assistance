import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchService {
  // Function to search users by username or email
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      // Convert query to lowercase for case-insensitive matching
      String lowerQuery = query.toLowerCase();

      // Search by username using prefix matching
      QuerySnapshot<Map<String, dynamic>> usersByUsername = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('username')
          .startAt([lowerQuery])
          .endAt(['$lowerQuery\uf8ff'])
          .get();

      // Search by email using prefix matching
      QuerySnapshot<Map<String, dynamic>> usersByEmail = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('email')
          .startAt([lowerQuery])
          .endAt(['$lowerQuery\uf8ff'])
          .get();

      // Combine results, ensuring no duplicates
      Map<String, Map<String, dynamic>> uniqueResults = {};

      for (var doc in usersByUsername.docs) {
        uniqueResults[doc.id] = {
          'id': doc.id,
          ...doc.data(),
        };
      }

      for (var doc in usersByEmail.docs) {
        uniqueResults[doc.id] = {
          'id': doc.id,
          ...doc.data(),
        };
      }

      return uniqueResults.values.toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }
}
