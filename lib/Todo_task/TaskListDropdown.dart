// import 'package:flutter/material.dart';
// import 'firestore_service.dart';
//
// class TaskListDropdown extends StatefulWidget {
//   const TaskListDropdown({super.key});
//
//   @override
//   State<TaskListDropdown> createState() => _TaskListDisplayState();
// }
//
// class _TaskListDisplayState extends State<TaskListDropdown> {
//   final FirestoreService _firestoreService = FirestoreService();
//   List<String> _lists = ['Default', 'Work', 'Personal', 'Urgent', 'Shopping'];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTaskLists();
//   }
//
//   Future<void> _loadTaskLists() async {
//     List<String> taskLists = await _firestoreService.getTaskLists();
//     setState(() {
//       _lists = ['Default', 'Work', 'Personal', 'Urgent', 'Shopping'] + taskLists;
//       _lists = _lists.toSet().toList(); // Remove duplicates
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Lists'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5), // Reduce padding
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey, width: 1), // Thinner outline
//             borderRadius: BorderRadius.circular(8), // Rounded corners
//           ),
//           height: 300, // Adjusted height for the container
//           width: 200,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Row for Home icon and All Lists text
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.home),
//                     onPressed: () {
//                       // Add logic for Home button action if needed
//                     },
//                   ),
//                   SizedBox(width: 8), // Space between Home icon and All Lists text
//                   Text(
//                     'All Lists',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ],
//               ),
//               Divider(thickness: 1.5, color: Colors.grey), // Thinner divider
//               SizedBox(height: 8),
//               // List of task names with Menu icon on the left
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _lists.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       //padding: const EdgeInsets.symmetric(vertical: 2.0), // Less vertical padding
//                       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.menu),
//                             onPressed: () {
//                               // Add logic for each task's menu icon
//                             },
//                           ),
//                           SizedBox(width: 2), // Space between the menu icon and task name
//                           Padding(
//                             padding: const EdgeInsets.only(left: 10.0), // Add padding for task name
//                             child: Text(
//                               _lists[index],
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ),
//
//
//
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
