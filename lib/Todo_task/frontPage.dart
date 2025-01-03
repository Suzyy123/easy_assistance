import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_assistance_app/Todo_task/ListsPgae.dart';
import 'package:easy_assistance_app/Todo_task/My%20Work.dart';
import 'package:easy_assistance_app/Todo_task/shopping.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ChatPage/ChatPageUI.dart';
import '../Components/icons.dart';
import '../ProfilePage/ProfileMain.dart';
import '../TodoTask_Service/TaskNotification/notification_icon.dart';
import '../TodoTask_Service/meeting notification/IconPAge.dart';
import 'Assignment.dart';
import 'Meeting_All/Meeting.dart';
import 'Meeting_All/MeetingPage.dart';
import 'Notes_All/All_Notes.dart';
import 'Notes_All/DocsPage.dart';
import 'Tasks_All/CompletedTasks.dart';
import 'Tasks_All/FavoriteTasks.dart';
import 'Tasks_All/TaskListPage.dart';
import 'Tasks_All/createPage.dart';
import 'default.dart';
import 'package:easy_assistance_app/TodoTask_Service/firestore_service.dart';
import 'package:easy_assistance_app/Todo_task/personal.dart'; // Personal page import
import 'package:intl/intl.dart'; // Ensure this is imported for DateFormat
import 'calendarScreen.dart';
import 'package:easy_assistance_app/TodoTask_Service/firestore_service.dart' as taskFirestore;



class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  List<String> taskLists = [];
  String? selectedList;
  bool _isDropdownOpened = false;
  bool isLoading = true;
  int taskCount = 0;
  String selectedNavItem = 'My Day';
  bool showCalendar = false;
  List<Map<String, String>> recentPages = [];
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String userId= FirebaseAuth.instance.currentUser!.uid;
  String? profileAvatar;
  @override
  void initState() {
    super.initState();
    _loadTaskCount();
    _loadTaskLists();
    searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    if (searchController.text.isNotEmpty) {
      setState(() => isSearching = true);
      searchFirestore(searchController.text);
    } else {
      setState(() {
        isSearching = false;
        searchResults = [];
      });
    }
  }
  //search code
  void searchFirestore(String query) async {
    // Get the current user's ID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print('User is not logged in.');
      return;
    }

    List<Map<String, dynamic>> tempResults = [];

    try {
      // Fetch tasks for the current user
      final tasksSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('UserId', isEqualTo: userId) // Filter by userId
          .get();

      // Filter locally for tasks that match the query
      final filteredTasks = tasksSnapshot.docs
          .where((doc) => (doc['task'] ?? '').toString().toLowerCase().contains(query.toLowerCase()))
          .map((doc) => {...doc.data(), 'type': 'task'});

      tempResults.addAll(filteredTasks);

      // Fetch meetings for the current user
      final meetingsSnapshot = await FirebaseFirestore.instance
          .collection('meetings')
          .where('UserId', isEqualTo: userId) // Filter by userId
          .get();

      // Filter locally for meetings that match the query
      final filteredMeetings = meetingsSnapshot.docs
          .where((doc) => (doc['title'] ?? '').toString().toLowerCase().contains(query.toLowerCase()))
          .map((doc) => {...doc.data(), 'type': 'meeting'});

      tempResults.addAll(filteredMeetings);

      // Fetch notes for the current user
      final notesSnapshot = await FirebaseFirestore.instance
          .collection('notes')
          .where('UserId', isEqualTo: userId) // Filter by userId
          .get();

      // Filter locally for notes that match the query
      final filteredNotes = notesSnapshot.docs
          .where((doc) => (doc['title'] ?? '').toString().toLowerCase().contains(query.toLowerCase()))
          .map((doc) => {...doc.data(), 'type': 'note'});

      tempResults.addAll(filteredNotes);

      // Update state with results
      setState(() {
        searchResults = tempResults;
      });

      print('Search results: $tempResults');
    } catch (e) {
      print('Error searching Firestore: $e');
    }
  }



  Future<void> _loadTaskCount() async {
    final tasks = await _firestoreService.getTasks(userId).first;
    final now = DateTime.now();
    final upcomingTasks = tasks.where((task) {
      final dueDate = _parseDueDate(task['dueDate'], task['dueTime']);
      return dueDate.isAfter(now) && dueDate.difference(now).inDays <= 3;
    }).toList();

    setState(() {
      taskCount = upcomingTasks.length;
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
        recentPages.removeAt(0);
      }
      recentPages.add({
        'page': page,
        'timestamp': DateTime.now().toString(),
      });
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      isSearching = false;
      searchResults.clear();
    });
  }

  Future<void> _loadTaskLists() async {
    taskLists = await _firestoreService.getTaskLists(userId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadProfileAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileAvatar = prefs.getString('selectedAvatar') ?? 'lib/images/default_avatar.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage: profileAvatar != null
                ? AssetImage(profileAvatar!)
                : const AssetImage('lib/images/avatar2.png'),
          ),
        ),
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextStyle(color: Colors.white), // Loading text in white
              );
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text(
                "Unknown User",
                style: TextStyle(color: Colors.white), // Unknown user text in white
              );
            }
            final userData = snapshot.data!;
            return Text(
              userData['username'] ?? 'No Username',
              style: const TextStyle(
                color: Colors.white,

              ),
            );
          },
        ),
        flexibleSpace: SafeArea(
          child: Center(
            child: Text(
              '',
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
            padding: const EdgeInsets.only(right: 20.0),
            child: MeetingNotificationIcon(), // Add your custom meeting notification icon widget
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: NotificationIcon_Task(), // Add your custom task notification icon widget
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
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
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
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      onSearchChanged();
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
                                      showCalendar = false;
                                    });
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
                                      showCalendar = false;
                                    });
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
                                      showCalendar = false;
                                    });
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
                                      showCalendar = false;
                                    });
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
                                      showCalendar = !showCalendar;
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
                                      showCalendar = false;
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
                                      showCalendar = false;
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
                          if(!_isDropdownOpened  && !isSearching && !showCalendar)
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 300),
                                    child: IconButton(
                                      icon: Icon(Icons.create, size: 30,
                                          color: Colors.blue[900]),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Create()));
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.note_alt_sharp, size: 30,
                                        color: Colors.blue[900]),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => NotePage()));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                        Icons.meeting_room_outlined, size: 30,
                                        color: Colors.blue[900]),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              CreateMeetingPage()));
                                    },
                                  ),
                                ]
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
                                        addToRecentPages(option);
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

                          if (showCalendar)
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: CalendarPage(),
                              ),
                            ),
                          Expanded(
                            child: isSearching && searchResults.isNotEmpty
                                ? ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final item = searchResults[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      item['type'] == 'note'
                                          ? (item['title'] ?? 'No Title')
                                          : (item['task'] ?? 'No Task'),
                                    ),
                                    subtitle: Text(
                                      item['type'] == 'note'
                                          ? (item['content'] ?? 'No Content')
                                          : item['type'] == 'meeting'
                                          ? 'Meeting'
                                          : 'List: ${item['list'] ?? 'No List'}\nDue Date: ${item['dueDate'] ?? 'N/A'}\nDue Time: ${item['dueTime'] ?? 'N/A'}',
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // Handle delete
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                                : isSearching && searchResults.isEmpty
                                ? Center(child: Text('No results found'))
                                : Container(),
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
      bottomNavigationBar: const NavigatorBar(),
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
          Icon(icon, color: isSelected ? Colors.white : Colors.grey),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 2),
              height: 1.5,
              width: 40,
              color: Colors.white,
            ),
        ],

      ),
      // Bottom Navigation Bar

    );

  }
}