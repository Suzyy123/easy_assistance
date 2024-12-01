// import 'package:flutter/material.dart';
// import 'firestore_service.dart';
//
// class ManageListsPage extends StatefulWidget {
//   const ManageListsPage({super.key});
//
//   @override
//   State<ManageListsPage> createState() => _ManageListsPageState();
// }
//
// class _ManageListsPageState extends State<ManageListsPage> {
//   final FirestoreService _firestoreService = FirestoreService();
//   final TextEditingController _newListController = TextEditingController();
//
//   List<String> _lists = ['Default', 'Work', 'Personal', 'Urgent', 'Shopping'];
//   String _selectedList = 'Default';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTaskLists();
//   }
//
//   // Fetch the lists from Firestore
//   Future<void> _loadTaskLists() async {
//     List<String> taskLists = await _firestoreService.getTaskLists();
//     setState(() {
//       _lists = ['Default', 'Work', 'Personal', 'Urgent', 'Shopping'] + taskLists;
//       _lists = _lists.toSet().toList(); // Remove duplicates
//     });
//   }
//
//   // Show dialog to add a new list
//   void _showAddListDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add New List'),
//           content: TextField(
//             controller: _newListController,
//             decoration: InputDecoration(
//               hintText: 'Enter list name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _newListController.clear();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (_newListController.text.isNotEmpty) {
//                   await _firestoreService.addNewTaskList(_newListController.text);
//                   await _loadTaskLists(); // Reload lists to include the new one
//                   setState(() {
//                     _selectedList = _newListController.text;
//                   });
//                 }
//                 Navigator.of(context).pop();
//                 _newListController.clear();
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[800],
//         title: Text('Manage Task Lists'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: Draggable(
//           data: 'ManageListsPage', // Data can be used if needed during drag
//           feedback: Material(
//             color: Colors.transparent,
//             child: Container(
//               width: 300,  // Adjust width to make the container small
//               height: 400, // Adjust height to make the container small
//               color: Colors.blueGrey.withOpacity(0.8),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),  // Adjust padding
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Task Lists',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Adjust text size
//                     ),
//                     SizedBox(height: 10), // Adjust space
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: _lists.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 5.0), // Reduce vertical space between items
//                             child: ListTile(
//                               contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Reduce ListTile padding
//                               title: Text(_lists[index]),
//                               trailing: Icon(Icons.check),
//                               onTap: () {
//                                 setState(() {
//                                   _selectedList = _lists[index];
//                                 });
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.add, color: Colors.blue, size: 30),  // Adjust icon size
//                           onPressed: _showAddListDialog,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           childWhenDragging: Container(
//             width: 300,  // Adjust width to make the container small
//             height: 400, // Adjust height to make the container small
//             color: Colors.blueGrey.withOpacity(0.5),
//             child: Center(child: Text("Dragging...", style: TextStyle(color: Colors.white))),
//           ),
//           child: Container(
//             width: 300,  // Adjust width to make the container small
//             height: 400, // Adjust height to make the container small
//             color: Colors.blueGrey.withOpacity(0.7),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),  // Adjust padding
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Task Lists',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Adjust text size
//                   ),
//                   SizedBox(height: 10), // Adjust space
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: _lists.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5.0), // Reduce vertical space between items
//                           child: ListTile(
//                             contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Reduce ListTile padding
//                             title: Text(_lists[index]),
//                             trailing: Icon(Icons.check),
//                             onTap: () {
//                               setState(() {
//                                 _selectedList = _lists[index];
//                               });
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.add, color: Colors.blue, size: 30),  // Adjust icon size
//                         onPressed: _showAddListDialog,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
