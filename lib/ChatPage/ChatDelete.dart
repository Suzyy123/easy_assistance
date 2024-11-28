import 'package:cloud_firestore/cloud_firestore.dart';

class Delete {
  Future<void> deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('messages') // Replace with your collection name
          .doc(messageId)
          .delete();
      print("Message deleted successfully.");
    } catch (e) {
      print("Error deleting message: $e");
    }
  }
}
