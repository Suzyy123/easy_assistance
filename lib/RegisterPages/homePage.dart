import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> mockData = ['Figma Design', 'Prototype', 'UI Tasks', 'Development']; // Mock search data

  void _handleSearch() {
    String searchQuery = _searchController.text.trim();

    // Check if the query exists in mock data
    bool isFound = mockData.any((item) => item.toLowerCase().contains(searchQuery.toLowerCase()));

    if (!isFound) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Not Found"),
            content: const Text("No results match your search. Please try another term."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // You can add additional functionality if the item is found (e.g., navigate or filter)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Found results for "$searchQuery"!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile_image.jpg'), // Profile image placeholder
            ),
            SizedBox(width: 10),
            Text(
              'Hi, Prapti. Welcome Back!',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Navigate to Notification Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Updated Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (value) => _handleSearch(),
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      // Important Projects Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Important Project",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            projectCard("Figma Design for prototype", "Very IMP", "Nov 11", "Dec 8"),
                            projectCard("Figma Design for prototype", "Very IMP", "Nov 11", "Dec 8"),
                            projectCard("Figma Design for prototype", "Very IMP", "Nov 11", "Dec 8"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // My Tasks Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "My Tasks",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            taskCard("To-Do", "Total: 5 tasks", Colors.blue),
                            taskCard("On-going", "Total: 2 tasks", Colors.orange),
                            taskCard("Done", "Total: 2 tasks", Colors.green),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Reminders Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Reminders",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text("November 22"),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Very Important",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Spacer(), // Ensures that the content adjusts to available space
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }

  // Function for project cards
  Widget projectCard(String title, String priority, String startDate, String endDate) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            priority,
            style: const TextStyle(color: Colors.white70),
          ),
          const Spacer(),
          Text(
            "Start Date: $startDate",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            "End Date: $endDate",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Function for task cards
  Widget taskCard(String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 40,
            color: color,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(description),
            ],
          ),
        ],
      ),
    );
  }
}

// Notification Page
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to HomePage
          },
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              notificationCard("New Task Assigned", "You have a new task: 'Complete Figma Prototype' due by Nov 25.", Colors.blue),
              notificationCard("Meeting Reminder", "Don't forget the project meeting tomorrow at 10 AM.", Colors.orange),
              notificationCard("Task Completed", "Great work! You completed the 'UI Redesign' task.", Colors.green),
              notificationCard("Deadline Update", "The deadline for 'Wireframe Design' has been extended to Nov 30.", Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  // Function for notification cards
  Widget notificationCard(String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(Icons.notifications, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

