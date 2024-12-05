// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class CalendarPage extends StatefulWidget {
//   final List<Map<String, dynamic>> tasks;
//
//   CalendarPage({required this.tasks});
//
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }
//
// class _CalendarPageState extends State<CalendarPage> {
//   DateTime _currentDate = DateTime.now();
//   List<int> _daysInMonth = [];
//   List<Map<String, dynamic>> _tasksForSelectedDate = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _generateDaysInMonth();
//   }
//
//   // Generate the list of days for the current month
//   void _generateDaysInMonth() {
//     final daysInMonth = <int>[];
//     final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
//     final lastDayOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);
//
//     for (int i = 1; i <= lastDayOfMonth.day; i++) {
//       daysInMonth.add(i);
//     }
//
//     setState(() {
//       _daysInMonth = daysInMonth;
//     });
//   }
//
//   // Update tasks for the selected date
//   void _updateTasksForDate(DateTime selectedDate) {
//     setState(() {
//       _tasksForSelectedDate = widget.tasks.where((task) {
//         final dueDate = DateFormat('dd, MMM yyyy').parse(task['dueDate']);
//         return dueDate.year == selectedDate.year &&
//             dueDate.month == selectedDate.month &&
//             dueDate.day == selectedDate.day;
//       }).toList();
//     });
//   }
//
//   // Helper method to calculate the task status
//   String _getTaskStatus(DateTime dueDate) {
//     final now = DateTime.now();
//     final difference = dueDate.difference(now).inDays;
//
//     if (difference < 0) {
//       return 'Overdue';
//     } else if (difference == 0) {
//       return 'Today';
//     } else {
//       return '$difference day(s) remaining';
//     }
//   }
//
//   // Build the calendar grid
//   Widget _buildCalendar() {
//     return Column(
//       children: [
//         // Display days of the month
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: _daysInMonth.map((day) {
//               return GestureDetector(
//                 onTap: () {
//                   final selectedDate = DateTime(_currentDate.year, _currentDate.month, day);
//                   _updateTasksForDate(selectedDate);
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.all(6),
//                   width: 70,
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     border: Border.all(color: Colors.black, width: 1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Display the day name (abbreviated)
//                       Text(
//                         DateFormat('EEE').format(DateTime(_currentDate.year, _currentDate.month, day)),
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue[900],
//                         ),
//                       ),
//                       // Display the date
//                       Text(
//                         '${day.toString().padLeft(2, '0')}',
//                         style: TextStyle(
//                           fontSize: 17,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         // Display tasks for the selected date
//         if (_tasksForSelectedDate.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: _tasksForSelectedDate.map((task) {
//                 final dueDate = DateFormat('dd, MMM yyyy').parse(task['dueDate']);
//                 final status = _getTaskStatus(dueDate);
//
//                 return Card(
//                   child: ListTile(
//                     title: Text(task['task']),
//                     subtitle: Text('Due: ${task['dueDate']} at ${task['dueTime']}'),
//                     trailing: Text(
//                       status,
//                       style: TextStyle(
//                         color: status == 'Overdue' ? Colors.red : Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         // If no tasks for selected date
//         if (_tasksForSelectedDate.isEmpty)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'No tasks for this date.',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.blue[800],
//       ),
//       body: Center(
//         child: _buildCalendar(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_assistance_app/Todo_task/firestore_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirestoreService firestoreService = FirestoreService();
  DateTime _currentDate = DateTime.now();
  List<int> _daysInMonth = [];
  List<Map<String, dynamic>> _tasksForSelectedDate = [];
  DateTime? _selectedDate; // Track the selected date


  @override
  void initState() {
    super.initState();
    _generateDaysInMonth();
  }

  // Generate the list of days for the current month
  void _generateDaysInMonth() {
    final daysInMonth = <int>[];
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDayOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);

    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      daysInMonth.add(i);
    }

    setState(() {
      _daysInMonth = daysInMonth;
    });
  }

  // Update tasks for the selected date
  void _updateTasksForDate(DateTime selectedDate, List<Map<String, dynamic>> tasks) {
    setState(() {
      _selectedDate = selectedDate; // Update the selected date
      _tasksForSelectedDate = tasks.where((task) {
        final dueDate = DateFormat('dd, MMM yyyy').parse(task['dueDate']);
        return dueDate.year == selectedDate.year &&
            dueDate.month == selectedDate.month &&
            dueDate.day == selectedDate.day;
      }).toList();
    });
  }

  // Helper method to calculate the task status
  String _getTaskStatus(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return 'Overdue';
    } else if (difference == 0) {
      return 'Today';
    } else {
      return '$difference day(s) remaining';
    }
  }

  // Build the calendar grid
  Widget _buildCalendar(List<Map<String, dynamic>> tasks) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              // Display days of the month
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _daysInMonth.map((day) {
                      final isSelected = _selectedDate != null &&
                          _selectedDate!.day == day &&
                          _selectedDate!.month == _currentDate.month &&
                          _selectedDate!.year == _currentDate.year;

                      return GestureDetector(
                        onTap: () {
                          final selectedDate = DateTime(_currentDate.year, _currentDate.month, day);
                          _updateTasksForDate(selectedDate, tasks);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(6),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[900] : Colors.transparent,
                            //color: Colors.transparent,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Display the day name (abbreviated)
                              Text(
                                DateFormat('EEE').format(DateTime(_currentDate.year, _currentDate.month, day)),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  //color: Colors.blue[900],
                                  color: isSelected ? Colors.white : Colors.blue[900],
                                ),
                              ),
                              // Display the date
                              Text(
                                '${day.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 16,
                                  //color: Colors.grey[700],
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Display tasks for the selected date
              if (_tasksForSelectedDate.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _tasksForSelectedDate.map((task) {
                      final dueDate = DateFormat('dd, MMM yyyy').parse(task['dueDate']);
                      final status = _getTaskStatus(dueDate);
                      // Determine color based on task status (Blue color for all tasks)
                      Color taskColor = Colors.grey[300]!; // Use blue for all task containers


                      return Card(
                        color: taskColor, // Light blue color for task container
                        child: ListTile(
                          title: Text(task['task']),
                          subtitle: Text('Due: ${task['dueDate']} at ${task['dueTime']}'),
                          trailing: Text(
                            status,
                            style: TextStyle(
                              color: status == 'Overdue' ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              // If no tasks for selected date
              SizedBox(height: 30),
              if (_tasksForSelectedDate.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No tasks for this date.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tasks to display.'),
            );
          }

          final tasks = snapshot.data!;

          return Center(child: _buildCalendar(tasks));
        },
      ),
    );
  }
}
