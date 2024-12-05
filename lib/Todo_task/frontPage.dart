import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_assistance_app/Todo_task/All_Notes.dart';
import 'package:easy_assistance_app/Todo_task/FavoriteTasks.dart';
import 'package:easy_assistance_app/Todo_task/ListsPgae.dart';
import 'package:easy_assistance_app/Todo_task/My%20Work.dart';
import 'package:easy_assistance_app/Todo_task/TaskListPage.dart';
import 'package:easy_assistance_app/Todo_task/shopping.dart';
import 'package:flutter/material.dart';
import 'Assignment.dart';
import 'MeetingPage.dart';
import 'default.dart';
import 'firestore_service.dart';
import 'resuable_ui.dart';
import 'package:easy_assistance_app/Todo_task/shopping.dart'; // Shopping page import
import 'package:easy_assistance_app/Todo_task/personal.dart'; // Personal page import
import 'package:easy_assistance_app/Todo_task/notification_icon.dart'; // Import NotificationIcon
import 'package:intl/intl.dart'; // Ensure this is imported for DateFormat
import 'package:flutter/material.dart';

import 'CompletedTasks.dart';
//import 'SearchResults.dart';
import 'addpage.dart';
import 'calendarScreen.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: TodoHomeScreen(),
    );
  }
}

class TodoHomeScreen extends StatefulWidget {
  @override
  _TodoHomeScreenState createState() => _TodoHomeScreenState();


}



class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> taskLists = [];  // To hold task lists from Firestore
  String? selectedList;  // The selected value in the dropdown
  bool _isDropdownOpened = false;
  bool isLoading = true;
  int taskCount = 0; // Initialize taskCount
  String selectedNavItem = 'My Day';
  bool showCalendar = false; // Flag to show CalendarPage
  List<Map<String, String>> recentPages = [];
  List<Map<String, String>> searchResults = []; // Store search results
  TextEditingController searchController = TextEditingController(); // Controller for search input
  bool isSearching = false; // Track whether the user is searching

  @override
  void initState() {
    super.initState();
    _loadTaskCount(); // Load task count on init
    _loadTaskLists(); // Load task lists on init
  }

  Future<void> _loadTaskCount() async {
    final tasks = await _firestoreService.getTasks().first;
    final now = DateTime.now();
    final upcomingTasks = tasks.where((task) {
      final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
      return dueDate.isAfter(now) && dueDate.difference(now).inDays <= 3;
    }).toList();

    setState(() {
      taskCount = upcomingTasks.length; // Update the task count
    });
  }

  DateTime _parseDueDate(String dueDate, String dueTime) {
    return DateFormat('dd, MMM yyyy hh:mm a').parse('$dueDate $dueTime');
  }

  List<String> menuOptions = ['Default', 'Shopping', 'Personal', 'Assignment'];

  final Map<String, Widget Function()> pages = {
    'Default': () => DefaultPage(),
    'Shopping': () => ShoppingPage(),
    'Personal': () => PersonalDetails(),
    'Assignment': () => AssignmentDetails(),
  };

  void _navigateToPage(String selectedOption) {
    if (pages.containsKey(selectedOption)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pages[selectedOption]!()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Page for "$selectedOption" not found')),
      );
    }
  }

  void addToRecentPages(String page) {
    setState(() {
      if (recentPages.length >= 5) {
        recentPages.removeAt(0); // Keep only the last 5 pages
      }
      recentPages.add({
        'page': page,
        'timestamp': DateTime.now().toString(), // Store the current time
      });
    });
  }

  void search(String query) {
    setState(() {
      searchResults = recentPages
          .where((page) => page['page']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isSearching = true; // Update the searching state
    });
  }

  Future<void> _loadTaskLists() async {
    taskLists = await _firestoreService.getTaskLists(); // Fetch data
    setState(() {
      isLoading = false;
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      isSearching = false;
      searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue[900],
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Center(
            child: Text(
              'Todo App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: NotificationIcon(taskCount: taskCount),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_isDropdownOpened) {
              setState(() {
                _isDropdownOpened = false;
              });
            }
          },
          child: Stack(
            children: [
              // Main content of the screen
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              Column(
                children: [
                  // Search bar and navigation section
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Search bar
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      search(value);
                                    } else {
                                      clearSearch();
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: clearSearch,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Navigation container
                        Container(
                          height: 64,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.refresh,
                                  label: 'Recents',
                                  isSelected: selectedNavItem == 'Recents',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Recents';
                                      showCalendar = false;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.task_outlined,
                                  label: 'All Tasks',
                                  isSelected: selectedNavItem == 'All Tasks',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'All Tasks';
                                      showCalendar = false; // Hide calendar

                                      if (!recentPages.any((page) => page['page'] == 'All Tasks')) {
                                        recentPages.add({
                                          'page': 'All Tasks',
                                          'timestamp': DateTime.now().toString(), // Store the current time
                                        });
                                      }

                                    });
                                    // Navigate to the Calendar screen when tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => TaskListPage()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.meeting_room_outlined,
                                  label: 'Meetings',
                                  isSelected: selectedNavItem == 'Meetings',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Meetings';
                                      showCalendar = false; // Hide calendar

                                      if (!recentPages.any((page) => page['page'] == 'Meetings')) {
                                        recentPages.add({
                                          'page': 'Meetings',
                                          'timestamp': DateTime.now().toString(), // Store the current time
                                        });
                                      }

                                    });
                                    // Navigate to the Calendar screen when tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MeetingsPage()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.calendar_today,
                                  label: 'Calendar',
                                  isSelected: selectedNavItem == 'Calendar',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Calendar';
                                      showCalendar = false; // Hide calendar

                                      if (!recentPages.any((page) => page['page'] == 'Table Calendar')) {
                                        recentPages.add({
                                          'page': 'Table Calendar',
                                          'timestamp': DateTime.now().toString(), // Store the current time
                                        });
                                      }

                                    });
                                    // Navigate to the Calendar screen when tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CalendarScreen()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.star_border,
                                  label: 'Favorites',
                                  isSelected: selectedNavItem == 'Favorites',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Favorites';
                                      showCalendar = false; // Hide calendar


                                      if (!recentPages.any((page) => page['page'] == 'Favorite Tasks')) {
                                        recentPages.add({
                                          'page': 'Favorite Tasks',
                                          'timestamp': DateTime.now().toString(), // Store the current time
                                        });
                                      }

                                    });
                                    //Navigate to the Calendar screen when "My Work" is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FavoriteTasksPage()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.assignment,
                                  label: 'My Work',
                                  isSelected: selectedNavItem == 'My Work',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'My Work';
                                      showCalendar = !showCalendar; // Toggle the calendar visibility


                                      if (!recentPages.any((page) => page['page'] == 'My Work')) {
                                        recentPages.add({
                                          'page': 'Completed Tasks',
                                          'timestamp': DateTime.now().toString(), // Store the current time
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.file_copy_sharp,
                                  label: 'Notes',
                                  isSelected: selectedNavItem == 'Notes',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Notes';

                                      showCalendar = false; // Hide calendar
                                      if (!recentPages.any((page) => page['page'] == 'Notes')) {
                                        recentPages.add({
                                          'page': 'Notes',
                                          'timestamp': DateTime.now().toString(), // Store the current time
                                        });
                                      }
                                    });


                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NotesPage()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.assignment_turned_in,
                                  label: 'Done tasks',
                                  isSelected: selectedNavItem == 'Done tasks',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Done tasks';
                                      showCalendar = false; // Hide calendar

                                      if (!recentPages.any((page) => page['page'] == 'Completed Tasks')) {
                                        recentPages.add({
                                          'page': 'Completed Tasks',
                                          'timestamp': DateTime.now().toString(), // Store the current time
                                        });
                                      }
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CompletedTasksPage()),
                                    );


                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.list_alt_rounded,
                                  label: 'All Lists',
                                  isSelected: selectedNavItem == 'Lists',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Lists';
                                      showCalendar = false;
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ListPage()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lists section
                  SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isDropdownOpened = !_isDropdownOpened;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'All Lists',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Icon(
                                    _isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          if (_isDropdownOpened)
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.home, color: Colors.black),
                                        SizedBox(width: 8),
                                        Text(
                                          'Home',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  ...menuOptions.map((option) {
                                    return InkWell(
                                      onTap: () {
                                        addToRecentPages(option); // Add to recent pages
                                        _navigateToPage(option);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.list, color: Colors.black),
                                            SizedBox(width: 8),
                                            Text(
                                              option,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          // Conditionally show the CalendarPage widget below All Lists text
                          if (showCalendar) // Conditionally show the CalendarPage widget
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: CalendarPage(), // Calendar will show here
                              ),
                            ),
                          Expanded(
                            child: selectedNavItem == 'Recents'
                                ? Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.2),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                itemCount: recentPages.length,
                                itemBuilder: (context, index) {
                                  // Sort the recentPages list by timestamp before displaying
                                  recentPages.sort((a, b) => DateTime.parse(b['timestamp']!).compareTo(DateTime.parse(a['timestamp']!)));

                                  var pageData = recentPages[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pageData['page']!,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Visited on: ${pageData['timestamp']}', // Display date and time
                                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                                : Container(), // Show other content if not 'Recents'
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Function() onTap;

  const NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.grey), // icon recents
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey, //txt icon
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 2), //line icon
              height: 1.5,
              width: 40,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? count;
  final bool isSelected;

  const ListItem({
    Key? key,
    required this.icon,
    required this.title,
    this.count,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[900]),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          if (count != null)
            CircleAvatar(
              backgroundColor: Colors.blue[900],
              radius: 12,
              child: Text(
                count!,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
//