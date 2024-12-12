
import 'package:easy_assistance_app/Todo_task/shoppingService.dart';
import 'package:flutter/material.dart';
import 'frontPage.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This removes the debug banner
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: TodoHomeScreen(),
    );
  }
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  _TodoHomeScreenState createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  // To track the selected icon
  String selectedNavItem = 'My Day';
  bool isMenuVisible = false;
  Offset menuPosition = Offset(100, 100); // Starting position of the draggable menu
  String selectedList = ''; // Track selected list category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Increase the height of the AppBar
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),

          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TodoApp()), // Navigate to TodoApp
            );
          },
        ),
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
                if (isMenuVisible) {
                  setState(() {
                    isMenuVisible = false; // Close the menu when tapping anywhere
                  });
                }
              },
              child: Column(
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

                  SizedBox(height: 10),
// Below section has been removed to clean up the code and remove lists and dropdown
    Expanded(
    child: ShoppingListPage(), // Directly call the ShoppingListPage here
    ),
                ],
              ),
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
    super.key,
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
