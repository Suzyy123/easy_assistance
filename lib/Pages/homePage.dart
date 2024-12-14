import 'package:easy_assistance_app/Components/icons.dart';
import 'package:easy_assistance_app/TodoTask_Service/TaskNotification/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ProfilePage/Settings/Drawer.dart';
import '../Pages/IconPAge.dart';
import 'friendRequestPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> mockData = ['Figma Design', 'Prototype', 'UI Tasks', 'Development'];

  // Handling Firestore data fetching for meetings
  late Stream<List<Map<String, dynamic>>> meetingsStream;

  @override
  void initState() {
    super.initState();

    meetingsStream = FirebaseFirestore.instance
        .collection('meetings')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return {
        'title': doc['title'] ?? '',
        'date': doc['date'] ?? '',
        'description': doc['description'] ?? '',
        'location': doc['location'] ?? '',
        'time': doc['time'] ?? '',
        'color': Colors.blue,  // Use a fixed color or dynamically set
      };
    }).toList());
  }

  // Handling search functionality
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
        backgroundColor: Colors.blue[900],
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...", style: TextStyle(color: Colors.white));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text("Hi, User", style: TextStyle(color: Colors.white));
            }
            final userData = snapshot.data!;
            return Text("Hi, ${userData['username'] ?? ' Username'}", style: const TextStyle(color: Colors.white));
          },
        ),
        actions: [
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.group_add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendRequestPage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: MeetingNotificationIcon(), // Meeting notification icon
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: NotificationIcon_Task(), // Task notification icon
          ),
        ],
      ),
      drawer: const MyDrawer(),
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

                      // Meetings Section (Stream from Firestore)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Meetings",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: meetingsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text("No meetings available"));
                          }

                          return SizedBox(
                            height: 140,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.map((meeting) {
                                return projectCard(
                                  meeting['title'] ?? '',
                                  meeting['description'] ?? 'No Description',
                                  meeting['date'] ?? 'No Date',
                                  meeting['time'] ?? 'No Time',
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),

                      // My Tasks Section
                      const SizedBox(height: 20),  // Added extra space before "My Tasks"
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "My Tasks",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),  // Adjusted space below the text for better alignment
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
                      // Displaying reminders
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
      bottomNavigationBar: NavigatorBar(),
    );
  }

  // Project Card Widget
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

  // Task Card Widget
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(description),
            ],
          ),
        ],
      ),
    );
  }

  // Reminders mock data
  List<Map<String, dynamic>> reminders = [
    {"title": "Finish coding", "date": "2024-12-15", "priority": "High", "color": Colors.red},
    {"title": "Complete design", "date": "2024-12-16", "priority": "Low", "color": Colors.green},
  ];
}
