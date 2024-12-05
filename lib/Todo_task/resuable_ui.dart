import 'package:flutter/material.dart';
import 'package:easy_assistance_app/Todo_task/Assignment.dart';
import 'package:easy_assistance_app/Todo_task/default.dart';
import 'package:easy_assistance_app/Todo_task/shopping.dart'; // Shopping page import
import 'package:easy_assistance_app/Todo_task/personal.dart'; // Personal page import

class TaskListDetailsPage1 extends StatelessWidget {
  final String listName;

  // Constructor to take listName as a parameter
  TaskListDetailsPage1({required this.listName});

  // Map of list names to their respective pages
  final Map<String, Widget Function()> pages = {
    'Default': () => DefaultPage(),
    'Shopping': () => ShoppingPage(),
    'Personal': () => PersonalDetails(),
    'Assignment': () => AssignmentDetails(),
    // Add other list names and their corresponding pages here
  };

  @override
  Widget build(BuildContext context) {
    // Check if the listName is in the map, otherwise show an error message
    if (pages.containsKey(listName)) {
      // If the listName is found, navigate to the corresponding page
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pages[listName]!()),
        );
      });
    } else {
      // If the list name is not in the map, show an error message
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No page found for "$listName"')),
        );
      });
    }

    // Default UI while waiting for the navigation
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks for $listName'),
      ),
      body: Center(
        child: Text(
          'Navigating to $listName tasks...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
