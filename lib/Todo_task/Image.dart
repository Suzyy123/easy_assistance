import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_assistance_app/Todo_task/All_Notes.dart';
import 'package:easy_assistance_app/Todo_task/FavoriteTasks.dart';
import 'package:easy_assistance_app/Todo_task/ListsPgae.dart';
import 'package:easy_assistance_app/Todo_task/My%20Work.dart';
import 'package:easy_assistance_app/Todo_task/TaskListPage.dart';
import 'package:easy_assistance_app/Todo_task/shopping.dart';
import 'Assignment.dart';
import 'default.dart';
import 'firestore_service.dart';
import 'resuable_ui.dart';
import 'package:easy_assistance_app/Todo_task/personal.dart'; // Personal page import
import 'package:easy_assistance_app/Todo_task/notification_icon.dart'; // Import NotificationIcon
import 'package:intl/intl.dart'; // Ensure this is imported for DateFormat
import 'CompletedTasks.dart';
import 'addpage.dart';
import 'calendarScreen.dart';

class App extends StatelessWidget {
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
  List<String> taskLists = []; // To hold task lists from Firestore
  String? selectedList; // The selected value in the dropdown
  bool _isDropdownOpened = false;
  bool isLoading = true;
  int taskCount = 0; // Initialize taskCount
  String selectedNavItem = 'My Day';
  bool showCalendar = false; // New flag to show CalendarPage

  Offset _offset = Offset(100, 200); // Set an initial position for the draggable widget

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

  // Fetch the number of upcoming tasks for notification
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

  // Helper: Parse due date and time from Firestore
  DateTime _parseDueDate(String dueDate, String dueTime) {
    return DateFormat('dd, MMM yyyy hh:mm a').parse('$dueDate $dueTime');
  }

  // List of dropdown menu options
  List<String> menuOptions = ['Default', 'Shopping', 'Personal', 'Assignment'];

  // Map of list names to their respective pages
  final Map<String, Widget Function()> pages = {
    'Default': () => DefaultPage(),
    'Shopping': () => ShoppingPage(),
    'Personal': () => PersonalDetails(),
    'Assignment': () => AssignmentDetails(),
  };

  // Function to navigate to the page based on the selected option
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

  // Add page to recent pages list
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

  // Perform search operation
  void search(String query) {
    setState(() {
      searchResults = recentPages
          .where((page) => page['page']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isSearching = true; // Update the searching state
    });
  }

  // Clear the search results
  void clearSearch() {
    setState(() {
      searchController.clear();
      isSearching = false;
      searchResults.clear();
    });
  }

  // Load task lists from Firestore
  Future<void> _loadTaskLists() async {
    taskLists = await _firestoreService.getTaskLists(); // Fetch data
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Increase the height of the AppBar
        backgroundColor: Colors.blue[900],
        elevation: 0,
        title: Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: NotificationIcon(taskCount: taskCount),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Close the dropdown if it's open
          if (_isDropdownOpened) {
            setState(() {
              _isDropdownOpened = false;
            });
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Main content of the screen
              Container(
                height: 160, // Transparent container height
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3), // Transparent blue overlay
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25), // Round bottom-left corner
                    bottomRight: Radius.circular(25), // Round bottom-right corner
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
                                    hintStyle: TextStyle(
                                      color: Colors.grey, // Set the color of the hint text here
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      search(value); // Trigger search
                                    } else {
                                      clearSearch(); // Clear search if input is empty
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: clearSearch, // Clear search button
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16), // Space between the search bar and the new container

                        // Navigation container
                        Container(
                          height: 64,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5), //9.5

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
                                      showCalendar = false; // Hide calendar
                                    });
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
                                    // Navigate to CalendarPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CalendarPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.list,
                                  label: 'All Lists',
                                  isSelected: selectedNavItem == 'All Lists',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'All Lists';
                                    });
                                    // Navigate to ListsPage
                                    // Navigator.push(
                                    //   context,
                                      //MaterialPageRoute(builder: (context) => ListsPage()),
                                    //);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NavItem(
                                  icon: Icons.star,
                                  label: 'Favorites',
                                  isSelected: selectedNavItem == 'Favorites',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'Favorites';
                                    });
                                    // Navigate to FavoritesPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FavoriteTasksPage()),
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

                  // Display search results or recent pages
                  Expanded(
                    child: isSearching
                        ? buildSearchResults()
                        : showCalendar
                        ? CalendarPage() // Show CalendarPage if showCalendar is true
                        : buildRecentPages(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the recent pages section
  Widget buildRecentPages() {
    return ListView.builder(
      itemCount: recentPages.length,
      itemBuilder: (context, index) {
        final recentPage = recentPages[index];
        final pageName = recentPage['page'] ?? 'Unknown Page';
        final timestamp = recentPage['timestamp'] ?? 'Unknown Time';

        return ListTile(
          title: Text(pageName),
          subtitle: Text('Visited on: $timestamp'),
        );
      },
    );
  }

  // Widget to build the search results
  Widget buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final searchResult = searchResults[index];
        final pageName = searchResult['page'] ?? 'Unknown Page';
        final timestamp = searchResult['timestamp'] ?? 'Unknown Time';

        return ListTile(
          title: Text(pageName),
          subtitle: Text('Visited on: $timestamp'),
        );
      },
    );
  }
}

// Widget for the navigation item
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
