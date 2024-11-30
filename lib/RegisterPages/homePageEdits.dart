import 'package:flutter/material.dart';

import 'friendRequestPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageEdits(),
    );
  }
}

class HomePageEdits extends StatefulWidget {
  const HomePageEdits({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageEdits> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> mockData = ['Figma Design', 'Prototype', 'UI Tasks', 'Development'];
  final List<Map<String, dynamic>> reminders = [
    {
      "title": "Team Meeting",
      "date": "Nov 28, 10:00 AM",
      "priority": "Urgent",
      "color": Colors.red,
    },
    {
      "title": "Client Presentation",
      "date": "Nov 30, 2:00 PM",
      "priority": "Important",
      "color": Colors.orange,
    },
    {
      "title": "Submit Report",
      "date": "Dec 8, 9:00 AM",
      "priority": "Upcoming",
      "color": Colors.green,
    },
  ];

  void _handleSearch() {
    String searchQuery = _searchController.text.trim();

    bool isFound = mockData.any(
          (item) => item.toLowerCase().contains(searchQuery.toLowerCase()),
    );

    if (!isFound) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Not Found"),
          content: const Text("No results match your search. Please try another term."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
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
              backgroundImage: AssetImage('assets/Images/5thProfile.jpg'),
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
            icon: const Icon(Icons.group_add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendRequestPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
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
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (_) => _handleSearch(),
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _searchController.clear,
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

                      // Important Projects
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Important Projects",
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
                            projectCard("Prototype Development", "High", "Nov 15", "Dec 12"),
                            projectCard("UI Redesign Tasks", "Critical", "Nov 20", "Dec 18"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // My Tasks
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

                      // Reminders
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Reminders",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...reminders.map((reminder) => ListTile(
                        leading: Icon(Icons.calendar_today, color: reminder['color']),
                        title: Text(reminder['title'] ?? "No Title"),
                        subtitle: Text(reminder['date'] ?? "No Date Provided"),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: reminder['color'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            reminder['priority'] ?? "No Priority",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      const Spacer(),
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
        onTap: (index) {},
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
          onPressed: () => Navigator.pop(context),
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
