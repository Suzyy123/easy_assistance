// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class DeleteTaskPage extends StatefulWidget {
//   @override
//   _DeleteTaskPageState createState() => _DeleteTaskPageState();
// }
//
// class _DeleteTaskPageState extends State<DeleteTaskPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<String> taskLists = [];  // List of task list names
//   String? selectedList;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTaskLists();
//   }
//
//   // Fetch task lists from Firebase
//   Future<void> _fetchTaskLists() async {
//     try {
//       // Fetch data from Firebase taskLists collection
//       QuerySnapshot snapshot = await _firestore.collection('taskLists').get();
//       setState(() {
//         taskLists = snapshot.docs.map((doc) => doc['name'] as String).toList();
//         selectedList = taskLists.isNotEmpty ? taskLists[0] : null;
//       });
//     } catch (e) {
//       print("Error fetching task lists: $e");
//     }
//   }
//
//   // Delete all tasks related to the selected list
//   Future<void> _deleteTasksFromList(String listName) async {
//     try {
//       // Find the tasks subcollection related to the list name
//       QuerySnapshot taskSnapshot = await _firestore
//           .collection('taskLists')
//           .doc(listName)  // Use list name as the document ID
//           .collection('tasks')  // Assuming tasks are in a subcollection
//           .get();
//
//       // Delete all tasks in the selected list
//       for (var task in taskSnapshot.docs) {
//         await task.reference.delete();
//       }
//
//       print("Tasks from list '$listName' deleted successfully.");
//       // Optionally delete the list itself
//       await _firestore.collection('taskLists').doc(listName).delete();
//       print("List '$listName' deleted successfully.");
//     } catch (e) {
//       print("Error deleting tasks: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Delete Tasks from List'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Dropdown to select a task list
//             DropdownButton<String>(
//               value: selectedList,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedList = newValue;
//                 });
//               },
//               items: taskLists
//                   .map((item) => DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(item),
//               ))
//                   .toList(),
//             ),
//             SizedBox(height: 20),
//             // Button to delete tasks related to the selected list
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedList != null) {
//                   _deleteTasksFromList(selectedList!);  // Delete tasks in the selected list
//                 }
//               },
//               child: Text('Delete Tasks from List'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
