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
  // To track the selected icon
  String selectedNavItem = 'My Day';
  bool isMenuVisible = false;
  Offset menuPosition = Offset(100, 100); // Starting position of the draggable menu
  String selectedList = ''; // Track selected list category
  Map<String, List<String>> tasks = {
    //'Personal': ['Buy groceries', 'Call mom'],
    'Personal': ['Personal tasks','Buy groceries', 'Call mom'],
    'Shopping': ['Buy new shoes', 'Order online'],
    'Work': ['Finish report', 'Send emails'],
    'Finished': ['Clean the house'],
  };



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
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (isMenuVisible) {
                  setState(() {
                    isMenuVisible = false; // Close the menu when tapping anywhere
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
                              icon: Icon(Icons.keyboard_arrow_down),
                              onPressed: () {
                                setState(() {
                                  isMenuVisible = !isMenuVisible;
                                });
                              },
                            ),
                          ),
                          //   ListItem(
                          //     icon: Icons.check_box_outline_blank,
                          //     title: 'Do work',
                          //     count: '1',
                          //     isSelected: true,
                          //   ),
                          //   ListItem(
                          //     icon: Icons.person_outline,
                          //     title: 'Personal',
                          //     count: null,
                          //   ),
                          //   ListItem(
                          //     icon: Icons.shopping_cart_outlined,
                          //     title: 'Shopping',
                          //     count: '2',
                          //   ),
                          //   ListItem(
                          //     icon: Icons.work_outline,
                          //     title: 'Tasks',
                          //     count: '2',
                          //   ),
                          //   ListItem(
                          //     icon: Icons.folder_outlined,
                          //     title: 'Finished',
                          //     count: '1',
                          //   ),
                          //   ListItem(
                          //     icon: Icons.add,
                          //     title: 'New List',
                          //     count: null,
                          //   ),

                          // Display tasks for selected list
                          if (tasks[selectedList] != null)
                            Expanded(
                              child: ListView.builder(
                                itemCount: tasks[selectedList]!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(tasks[selectedList]![index]),
                                  );
                                },
                              ),
                            ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isMenuVisible)
              Positioned(
                left: menuPosition.dx,
                top: menuPosition.dy,
                child: Draggable(
                  feedback: _buildMenu(),
                  child: _buildMenu(),
                  onDragEnd: (details) {
                    setState(() {
                      menuPosition = details.offset;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Menu widget to be used for the draggable menu
  Widget _buildMenu() {
    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 220,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('All List'),
              onTap: () {},
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: GestureDetector(
                onTapDown: (TapDownDetails details) async {
                  final menuItem = await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      MediaQuery.of(context).size.width - details.globalPosition.dx,
                      MediaQuery.of(context).size.height - details.globalPosition.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  );

                  // Handle menu item selection
                  if (menuItem != null) {
                    if (menuItem == 'Edit') {
                      print('Edit selected');
                      // Add Edit functionality here
                    } else if (menuItem == 'Delete') {
                      print('Delete selected');
                      // Add Delete functionality here
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.format_list_bulleted_sharp, size: 24),
                    SizedBox(width: 10),
                    Text('Default', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedList = 'Personal';
                    // Add logic to display personal-related tasks here
                  });
                },
                //padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  children: [
                    Icon(Icons.format_list_bulleted_sharp, size: 24),
                    SizedBox(width: 10),
                    Text('Personal', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                children: [
                  Icon(Icons.format_list_bulleted_sharp, size: 24),
                  SizedBox(width: 10),
                  Text('Shopping', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                children: [
                  Icon(Icons.format_list_bulleted_sharp, size: 24),
                  SizedBox(width: 10),
                  Text('Work', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                children: [
                  Icon(Icons.format_list_bulleted_sharp, size: 24),
                  SizedBox(width: 10),
                  Text('Me', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.add_card_outlined),
              title: Text('Add'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Addpage()), // Replace SecondPage with your target page
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.check_box),
              title: Text('Finished'),
              onTap: () {},
            ),

          ],
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