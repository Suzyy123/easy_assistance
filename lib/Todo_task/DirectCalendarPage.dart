// // import 'package:flutter/material.dart';
// // import 'package:easy_assistance_app/Todo_task/firestore_service.dart';
// // import 'My Work.dart';  // Import the CalendarPage
// //
// // class NotificationPage1 extends StatelessWidget {
// //   final FirestoreService firestoreService = FirestoreService();
// //
// //   NotificationPage1({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.blue[900],
// //         title: const Text(
// //           'Task Notifications',
// //           style: TextStyle(color: Colors.white), // Make the title text white
// //         ),
// //         iconTheme: const IconThemeData(color: Colors.white),
// //       ),
// //       body: StreamBuilder<List<Map<String, dynamic>>>( // Fetch tasks
// //         stream: firestoreService.getTasks(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //
// //           if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return const Center(
// //               child: Text('No tasks to display.'),
// //             );
// //           }
// //
// //           // Get tasks from the snapshot
// //           final tasks = snapshot.data!;
// //
// //           return Center(
// //             child: ElevatedButton(
// //               onPressed: () {
// //                 // Navigate to CalendarPage and pass the tasks
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => CalendarPage(tasks: tasks), // Pass the tasks to CalendarPage
// //                   ),
// //                 );
// //               },
// //               child: const Text('Go to Calendar'),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:easy_assistance_app/Todo_task/resuable_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_assistance_app/Todo_task/firestore_service.dart';
// import 'My Work.dart';  // Import the CalendarPage
//
// class NotificationPage1 extends StatefulWidget {
//   @override
//   _NotificationPage1State createState() => _NotificationPage1State();
// }
//
// class _NotificationPage1State extends State<NotificationPage1> {
//   final FirestoreService firestoreService = FirestoreService();
//   String selectedNavItem = 'Recents'; // Default selected item
//
//   void _onNavItemSelected(String navItem) {
//     setState(() {
//       selectedNavItem = navItem;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Custom AppBar
//       appBar: customAppBar(
//         context,
//         'Todo App', // Title as per your image
//             () => Navigator.pop(context), // Back button callback
//       ),
//       body: Column(
//         children: [
//           // Search bar as seen in the image
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: customSearchBar(),
//           ),
//
//           // NavBar below the search bar (Recents, Calendar, etc.)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: NavBar(
//               selectedNavItem: selectedNavItem, // Default item
//               onNavItemSelected: _onNavItemSelected, // Handle selection
//             ),
//           ),
//
//           // Middle content with "Go to Calendar" button
//           Expanded(
//             child: Center(
//               child: StreamBuilder<List<Map<String, dynamic>>>(
//                 stream: firestoreService.getTasks(), // Fetch tasks
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(
//                       child: Text('No tasks to display.'),
//                     );
//                   }
//
//                   // Get tasks from the snapshot
//                   final tasks = snapshot.data!;
//
//                   return ElevatedButton(
//                     onPressed: () {
//                       // Navigate to CalendarPage with tasks
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CalendarPage(tasks: tasks),
//                         ),
//                       );
//                     },
//                     child: const Text('Go to Calendar'),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       // Custom NavBar with a transparent overlay
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.blue[900]!.withOpacity(0.9), // Add transparency
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: NavBar(
//           selectedNavItem: selectedNavItem, // Default item
//           onNavItemSelected: _onNavItemSelected, // Handle item selection
//         ),
//       ),
//     );
//   }
// }
