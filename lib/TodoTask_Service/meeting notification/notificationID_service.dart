import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class meetingService1 with ChangeNotifier {
  int unreadMeetingCount = 0; // Track unread meeting count

  FirestoreService() {
    // Initialize and start listening for meeting updates
    listenToUnreadMeetings();
  }

  // Listen to changes in Firestore for unread meetings
  void listenToUnreadMeetings() {
    FirebaseFirestore.instance
        .collection('meetings')  // Assuming meetings collection in Firestore
        .where('status', isEqualTo: 'unread') // Fetch only unread meetings
        .snapshots()
        .listen((snapshot) {
      unreadMeetingCount = snapshot.docs.length;  // Count of unread meetings
      notifyListeners();  // Notify UI to update badge
    });
  }

  // Reset unread count when user interacts with meeting notifications
  void resetUnreadMeetingCount() {
    FirebaseFirestore.instance
        .collection('meetings')
        .where('status', isEqualTo: 'unread')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'status': 'read'});  // Mark each meeting as read
      }
    });

    unreadMeetingCount = 0;
    notifyListeners();  // Reset badge count
  }
}
