import 'package:flutter/material.dart';
import 'Addpage.dart'; // Import Addpage for task list container

class TodoTask extends StatefulWidget {
  const TodoTask({super.key});

  @override
  _TodoTaskState createState() => _TodoTaskState();
}

class _TodoTaskState extends State<TodoTask> {
  bool _isDropdownOpened = false;
  Offset _offset = Offset(100, 200); // Initial position for the draggable Addpage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Task'),
      ),
      body: Stack( // Use Stack to layer widgets and allow free positioning
        children: [
          // Fixed Header: Task List with Dropdown Icon
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Task List',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(_isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                      onPressed: () {
                        setState(() {
                          _isDropdownOpened = !_isDropdownOpened; // Toggle Addpage visibility
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Conditionally show the draggable task list container when the dropdown is opened
          if (_isDropdownOpened)
            Positioned(
              left: _offset.dx,
              top: _offset.dy,
              child: Draggable(
                feedback: Material(
                  color: Colors.transparent, // Make feedback transparent
                  child: SizedBox( // Use SizedBox for size constraints
                    width: 220,
                    height: 300,
                    child: Addpage(), // Use Addpage for the content
                  ),
                ),
                childWhenDragging: Container(), // Placeholder when the widget is being dragged
                onDragEnd: (details) {
                  setState(() {
                    _offset = details.offset; // Update the position when drag ends
                  });
                },
                child: Addpage(), // The original Addpage displayed
              ),
            ),
        ],
      ),
    );
  }
}
