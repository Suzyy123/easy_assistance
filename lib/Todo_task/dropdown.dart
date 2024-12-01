// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// // void main() async {
// //   // Ensure Firebase is initialized before your app starts
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Firebase List Fetch',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: TodoHomeScreen(),
// //     );
// //   }
// // }
//
// class TodoHomeScreen extends StatefulWidget {
//   @override
//   _TodoHomeScreenState createState() => _TodoHomeScreenState();
// }
//
// class _TodoHomeScreenState extends State<TodoHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lists from Firebase'),
//       ),
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           // Fetching data from Firestore collection 'lists'
//           stream: FirebaseFirestore.instance.collection('lists').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return Center(child: Text('No lists found'));
//             }
//
//             // Get the list of document data from Firestore
//             var lists = snapshot.data!.docs;
//
//             return ListView.builder(
//               itemCount: lists.length,
//               itemBuilder: (context, index) {
//                 var listData = lists[index];
//                 var listName = listData['name']; // 'name' is the field from Firestore document
//
//                 return ListTile(
//                   title: Text(listName),
//                   onTap: () {
//                     // Handle tap on a list item
//                     print('Selected List: $listName');
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
