
import 'package:easy_assistance_app/Todo_task/shopping.dart';
import 'package:flutter/material.dart';

import 'addpage.dart';

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
  bool _isDropdownOpened = false;
  bool isLoading = true;

  // To track the selected icon
  String selectedNavItem = 'My Day';
  bool isMenuVisible = false;
  Offset menuPosition = Offset(100, 100); // Starting position of the draggable menu
  String selectedList = ''; // Track selected list category
  // Map<String, List<String>> tasks = {
  //   //'Personal': ['Buy groceries', 'Call mom'],
  //   'Personal': ['Personal tasks','Buy groceries', 'Call mom'],
  //   'Shopping': ['Buy new shoes', 'Order online'],
  //   'Work': ['Finish report', 'Send emails'],
  //   'Finished': ['Clean the house'],
  // };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Increase the height of the AppBar
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
      ),
      body:GestureDetector(
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
                  bottomLeft: Radius.circular(25),  // Round bottom-left corner
                  bottomRight: Radius.circular(25), // Round bottom-right corner
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                // Close the dropdown if it's open
                if (_isDropdownOpened) {
                  setState(() {
                    _isDropdownOpened = false;
                  });
                }
              },

              child: Column(  // Main Column widget with all content
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
                                  decoration: InputDecoration(
                                    hintText: 'Search here...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Icon(Icons.mic, color: Colors.grey),
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
                                  label: 'My Day',
                                  isSelected: selectedNavItem == 'My Day',
                                  onTap: () {
                                    setState(() {
                                      selectedNavItem = 'My Day';
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
                                    });
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
                                    });
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
                                    });
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
                                    });
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
                                    });
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
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'All Lists',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: Icon(_isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                              onPressed: () {
                                setState(() {
                                  _isDropdownOpened = !_isDropdownOpened;
                                });
                              },
                            ),
                          ),

// Conditionally show task list container from Addpage when dropdown is opened
                          _isDropdownOpened
                              ? Addpage() // Show task list container from Addpage when dropdown is opened
                              : Container(), // Empty container when dropdown is closed
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
              margin: EdgeInsets.only(top: 7),
              height: 2,
              width: 30,
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