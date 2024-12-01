// import 'package:flutter/material.dart';
//
// class DraggableMenuPage extends StatefulWidget {
//   @override
//   _DraggableMenuPageState createState() => _DraggableMenuPageState();
// }
//
// class _DraggableMenuPageState extends State<DraggableMenuPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Todo App'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             // Drawer Header
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             // Home Icon (non-functional)
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {},
//             ),
//             // All List Item (non-functional)
//             ListTile(
//               leading: Icon(Icons.list),
//               title: Text('All List'),
//               onTap: () {},
//             ),
//             // Other Menu Items
//             ListTile(
//               leading: Icon(Icons.category),
//               title: Text('Default'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Personal'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.shopping_cart),
//               title: Text('Shopping'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.work),
//               title: Text('Work'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.account_circle),
//               title: Text('Me'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.add),
//               title: Text('Add'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.check_box),
//               title: Text('Finished'),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Text(
//           'Drag the menu to see it in action!',
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: DraggableMenuPage(),
//   ));
// }
