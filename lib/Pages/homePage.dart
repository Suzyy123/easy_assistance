import 'package:easy_assistance_app/Components/icons.dart';
import 'package:easy_assistance_app/TodoTask_Service/TaskNotification/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../ChatPage/FriendRequestPage.dart';
import '../ProfilePage/Settings/Drawer.dart';
import '../TodoTask_Service/meeting notification/IconPAge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> mockData = ['Figma Design', 'Prototype', 'UI Tasks', 'Development'];
  int totalTasks = 0;
  int completedTasks = 0;
  int get ongoingTasks => totalTasks - completedTasks;
  // Handling Firestore data fetching for meetings
  late Stream<List<Map<String, dynamic>>> meetingsStream;
  late Stream<List<Map<String, dynamic>>> notesStream;

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
  Future<void> fetchTasks() async {
    try {
      // Get the current user's ID
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        debugPrint('User is not logged in.');
        return;
      }

      // Query Firestore for tasks
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('UserId', isEqualTo: userId)
          .get();

      int total = querySnapshot.docs.length;
      int completed = querySnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return data?['isCompleted'] == true;
      }).length;

      // Debug: Print all tasks and dueDate fields
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        debugPrint('Raw Task: $data');
        debugPrint('dueDate: ${data?['dueDate']}');
      }

      // Update state variables
      setState(() {
        totalTasks = total;
        completedTasks = completed;
      });

      debugPrint("Total Tasks: $total");
      debugPrint("Completed Tasks: $completed");
    } catch (e, stacktrace) {
      debugPrint('Error fetching tasks: $e');
      debugPrint('Stacktrace: $stacktrace');
    }
  }

//Function to create a Firestore Stream for notes
  Stream<List<Map<String, dynamic>>> getNotesStream() {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Stream.error('User is not logged in.');
    }

    return FirebaseFirestore.instance
        .collection('notes')
        .where('UserId', isEqualTo: userId) // Filter notes by UserId
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
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
    backgroundColor: Colors.blue[900],
      title: Row(
        children: [
          Flexible(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text(
                    "Hi, User",
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  );
                }
                final userData = snapshot.data!;
                return Text(
                  "Hi, ${userData['username'] ?? 'Username'}",
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          const Spacer(), // Pushes icons to the far right
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MeetingNotificationIcon(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: NotificationIcon_Task(),
          ),
        ],
      ),
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
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black, // Border color
                                width: 1.0,
                              ),
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
                      // My Tasks
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "My Tasks",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      //Task Lists
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 340,
                                decoration: BoxDecoration(
                                    color: Colors.white70, // Background color
                                    borderRadius: BorderRadius.circular(8), // Rounded corners
                                    border: Border.all( color: Colors.black)
                                ),
                                padding: EdgeInsets.all(16), // Inner padding

                                child: Text(
                                  'Total Tasks: 6',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 340,
                                decoration: BoxDecoration(
                                  color: Colors.white70, // Background color
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                  border: Border.all(color: Colors.black), // Border color and style
                                ),
                                padding: EdgeInsets.all(16), // Inner padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                                  children: [
                                    Text(
                                      "On going Task",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5), // Spacing between the two texts
                                    Text(
                                      'On going Tasks: $ongoingTasks',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black, // Text color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 340,
                                decoration: BoxDecoration(
                                  color: Colors.white70, // Background color
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                  border: Border.all(color: Colors.black), // Border color and style
                                ),
                                padding: EdgeInsets.all(16), // Inner padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                                  children: [
                                    Text(
                                      "Completed Task",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5), // Spacing between the two texts
                                    Text(
                                      'On going Tasks: $completedTasks',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black, // Text color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                      const SizedBox(height: 20),


                      // Reminders Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Title
                            const Text(
                              "Reminders",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10), // Add some spacing below the title

                            // Reminder Container
                            Container(
                              width: double.infinity, // Make the container take full width
                              decoration: BoxDecoration(
                                color: Colors.white70, // Background color
                                borderRadius: BorderRadius.circular(8), // Rounded corners
                                border: Border.all(color: Colors.black), // Border color
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16), // Inner padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                                children: [
                                  const Text(
                                    "😊Hey make sure to complete your homework on time"
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

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
