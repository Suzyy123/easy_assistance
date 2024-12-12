// import 'package:flutter/material.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firestore_service.dart';
//
// class crepage extends StatefulWidget {
//   const Create({super.key});
//
//   @override
//   State<Create> createState() => _CreateState();
// }
//
// // These controllers are used to manage the text in the input fields. They allow us to get or set the text value for the task, date, and time fields.
// class _CreateState extends State<Create> {
//   final TextEditingController _taskController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _timeController = TextEditingController();
//   final FirestoreService _firestoreService = FirestoreService();
//   final TextEditingController _newListController = TextEditingController();
//
//   // Variable to store selected list from dropdown
//   String _selectedList = 'Default';
//
//   // Method to pick a date
//   Future<void> _pickDate() async {
//     DateTime currentDate = DateTime.now();
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: currentDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         // Format date to "DD, MMM YYYY"
//         _dateController.text =
//         '${pickedDate.day}, ${_getMonthName(pickedDate.month)} ${pickedDate.year}';
//       });
//     }
//   }
//
//   // Method to pick time
//   Future<void> _pickTime() async {
//     TimeOfDay currentTime = TimeOfDay.now();
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: currentTime,
//     );
//
//     if (pickedTime != null) {
//       setState(() {
//         // Format time to "HH : MM am/pm"
//         _timeController.text = '${pickedTime.format(context)}';
//       });
//     }
//   }
//
//   // Helper method to convert month number to month name
//   String _getMonthName(int month) {
//     List<String> monthNames = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return monthNames[month - 1];
//   }
//
//   // Method to clear all fields
//   void _clearFields() {
//     setState(() {
//       _taskController.clear(); // Clears the task text field
//       _dateController.clear(); // Clears the date text field
//       _timeController.clear(); // Clears the time text field
//       _selectedList = 'Default'; // Resets the dropdown value
//       _newListController.clear(); // Clears the new list text field
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[800],
//         toolbarHeight: 120,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             size: 40,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           "New Task",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // "What is to be done?"
//             Text(
//               "What is to be done?",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             TextField(
//               controller: _taskController,
//               decoration: InputDecoration(
//                 suffixIcon: Icon(Icons.calendar_today),
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter task',
//                 hintStyle: TextStyle(color: Colors.grey),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // "Due Date"
//             Text(
//               "Due Date",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             TextField(
//               controller: _dateController,
//               decoration: InputDecoration(
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.date_range),
//                   onPressed: _pickDate, // Open calendar on click
//                 ),
//                 border: OutlineInputBorder(),
//                 hintText: 'Select due date',
//                 hintStyle: TextStyle(color: Colors.grey),
//               ),
//               readOnly: true, // Disable manual editing
//             ),
//             SizedBox(height: 20),
//
//             // "Due Time"
//             Text(
//               "Due Time",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             TextField(
//               controller: _timeController,
//               decoration: InputDecoration(
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.access_time),
//                   onPressed: _pickTime, // Open clock on click
//                 ),
//                 border: OutlineInputBorder(),
//                 hintText: 'Select due time',
//                 hintStyle: TextStyle(color: Colors.grey),
//               ),
//               readOnly: true, // Disable manual editing
//             ),
//             SizedBox(height: 20),
//
//             // Add to List and New List
//             Text(
//               "Add to List",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: DropdownButton<String>(
//                     value: _selectedList, // Use the state variable
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedList = newValue!; // Update the state
//                       });
//                     },
//                     items: <String>['Default', 'Work', 'Personal', 'Urgent', 'Shopping']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     isExpanded: true,
//                     hint: Text('Select a list'),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   flex: 3,
//                   child: TextField(
//                     controller: _newListController,
//                     decoration: InputDecoration(
//                       suffixIcon: Icon(Icons.add),
//                       border: OutlineInputBorder(),
//                       hintText: 'New list',
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 40),
//
//             // Submit Button
//             ElevatedButton(
//               onPressed: () async {
//                 if (_taskController.text.isNotEmpty &&
//                     _dateController.text.isNotEmpty &&
//                     _timeController.text.isNotEmpty) {
//                   try {
//                     await _firestoreService.addTask(
//                       _taskController.text,
//                       _dateController.text,
//                       _timeController.text,
//                       _selectedList,
//                     );
//
//                     _clearFields();
//
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Task added successfully')),
//                     );
//                   } catch (e) {
//                     print('Error adding task: $e');
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Failed to add task: $e')),
//                     );
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Please fill in all fields')),
//                   );
//                 }
//               },
//               child: Text("Submit"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 textStyle: TextStyle(fontSize: 16),
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // Clear Button
//             ElevatedButton(
//               onPressed: _clearFields,
//               child: Text("Clear"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 textStyle: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
