// import 'package:flutter/material.dart';
//
// class Recents extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<Recents> {
//   // List to store recent pages
//   List<String> recentPages = [];
//
//   // Add a recent page to the list
//   void _addRecentPage(String pageName) {
//     setState(() {
//       if (recentPages.length == 5) {  // Limit to 5 recent pages
//         recentPages.removeAt(0);  // Remove the oldest page
//       }
//       recentPages.add(pageName);  // Add the new page
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Recent Pages Example"),
//         ),
//         drawer: Drawer(
//           child: ListView(
//             children: [
//               ListTile(
//                 title: Text('Home'),
//                 onTap: () {
//                   _addRecentPage('Home');
//                   Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
//                 },
//               ),
//               ListTile(
//                 title: Text('Page 1'),
//                 onTap: () {
//                   _addRecentPage('Page 1');
//                   Navigator.push(context, MaterialPageRoute(builder: (_) => Page1()));
//                 },
//               ),
//               ListTile(
//                 title: Text('Page 2'),
//                 onTap: () {
//                   _addRecentPage('Page 2');
//                   Navigator.push(context, MaterialPageRoute(builder: (_) => Page2()));
//                 },
//               ),
//               // Display recent pages
//               ExpansionTile(
//                 title: Text("Recent Pages"),
//                 children: recentPages.map((page) {
//                   return ListTile(
//                     title: Text(page),
//                     onTap: () {
//                       // Navigate to the respective page (for simplicity, showing a placeholder)
//                       print("Navigating to $page");
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//         body: Center(
//           child: Text('Select a page from the drawer'),
//         ),
//       ),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home Page')),
//       body: Center(child: Text('This is the Home Page')),
//     );
//   }
// }
//
// class Page1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Page 1')),
//       body: Center(child: Text('This is Page 1')),
//     );
//   }
// }
//
// class Page2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Page 2')),
//       body: Center(child: Text('This is Page 2')),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'frontPage.dart';  // Replace with actual imports
import 'All_Notes.dart';    // Replace with actual imports
import 'Assignment.dart';    // Replace with actual imports
import 'calendarScreen.dart';
import 'CompletedTasks.dart';
import 'default.dart';
import 'DocsPage.dart';
import 'FavoriteTasks.dart';
import 'ListsPgae.dart';
import 'My Work.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // List to store recent pages
  List<String> recentPages = [];

  // Add a recent page to the list
  void _addRecentPage(String pageName) {
    setState(() {
      if (recentPages.length == 5) {  // Limit to 5 recent pages
        recentPages.removeAt(0);  // Remove the oldest page
      }
      recentPages.add(pageName);  // Add the new page
    });
  }

  // Navigate to the respective page
  void _navigateToPage(BuildContext context, String pageName) {
    if (pageName == 'ListPage') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ListPage()),
      );
    } else if (pageName == 'CompletedTasksPage') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CompletedTasksPage()),
      );
    } else if (pageName == 'CalendarScreen') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CalendarScreen()),
      );
    } else if (pageName == 'NotesPage') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NotesPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Recent Pages Example"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text('ListPage'),
                onTap: () {
                  _addRecentPage('ListPage');
                  _navigateToPage(context, 'ListPage');
                },
              ),
              ListTile(
                title: Text('CompletedTasksPage'),
                onTap: () {
                  _addRecentPage('CompletedTasksPage');
                  _navigateToPage(context, 'CompletedTasksPage');
                },
              ),
              ListTile(
                title: Text('NotesPage'),
                onTap: () {
                  _addRecentPage('NotesPage');
                  _navigateToPage(context, 'NotesPage');
                },
              ),
              ListTile(
                title: Text('CalendarScreen'),
                onTap: () {
                  _addRecentPage('CalendarScreen');
                  _navigateToPage(context, 'CalendarScreen');
                },
              ),
              // Display recent pages
              ExpansionTile(
                title: Text("Recent Pages"),
                children: recentPages.map((page) {
                  return ListTile(
                    title: Text(page),
                    onTap: () {
                      _navigateToPage(context, page);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        body: Center(
          child: Text('Select a page from the drawer'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListPage')),
      body: Center(child: Text('This is ListPage')),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CompletedTasksPage')),
      body: Center(child: Text('This is CompletedTasksPage')),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NotesPage')),
      body: Center(child: Text('This is NotesPage')),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CalendarScreen')),
      body: Center(child: Text('This is CalendarScreen')),
    );
  }
}


