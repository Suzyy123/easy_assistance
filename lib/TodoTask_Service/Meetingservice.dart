// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MeetingService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Method to add a meeting to Firestore
//   Future<void> addMeeting({
//     required String title,
//     required String description,
//     required String location,
//     required String date,
//     required String time,
//   }) async {
//     try {
//       await _firestore.collection('meetings').add({
//         'title': title,
//         'description': description,
//         'location': location,
//         'date': date,
//         'time': time,
//         'created_at': FieldValue.serverTimestamp(),
//         'updated_at': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error adding meeting: $e");
//     }
//   }
//   // Stream method to fetch meetings from Firestore
//   Stream<List<Map<String, dynamic>>> getMeetings() {
//     return _firestore.collection('meetings').snapshots().map((snapshot) =>
//         snapshot.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           data['id'] = doc.id; // Add document ID for reference
//           return data;
//         }).toList());
//   }
//
// // Method to delete a meeting from Firestore
//   Future<void> deleteMeeting(String meetingId) async {
//     try {
//       // Delete the meeting by its ID
//       await _firestore.collection('meetings').doc(meetingId).delete();
//       print('Meeting deleted successfully');
//     } catch (e) {
//       print('Error deleting meeting: $e');
//     }
//   }
//
//   // Method to edit a meeting in Firestore
//   Future<void> editMeeting(String meetingId, String title, String description, String date, String time, String location) async {
//     try {
//       // Update the meeting with the new values
//       await _firestore.collection('meetings').doc(meetingId).update({
//         'title': title,
//         'description': description,
//         'date': date,
//         'time': time,
//         'location': location,
//         'updated_at': FieldValue.serverTimestamp(),  // Optional: Track the last update time
//       });
//       print('Meeting updated successfully');
//     } catch (e) {
//       print('Error updating meeting: $e');
//     }
//   }
//
//
// }
