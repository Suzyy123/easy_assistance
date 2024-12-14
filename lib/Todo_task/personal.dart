import 'package:flutter/material.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  double searchBarPosition = 40.0; // Initial position of the search bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        toolbarHeight: 80,
      ),

      body: Column( // Use Column to stack all items vertically
        children: [
          // Stack for the overlay and other positioned elements
          Stack( // Stack to position the overlay and search bar
            children: [
              // Main content of the screen
              Container(
                height: 200, // Transparent container height
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3), // Transparent blue overlay
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),  // Round bottom-left corner
                    bottomRight: Radius.circular(25), // Round bottom-right corner
                  ),
                ),
              ),

              // Positioned search bar container inside the overlay container
              Positioned(
                top: searchBarPosition, // Position based on searchBarPosition value
                left: 16,
                right: 16,
                child: Container(
                  height: 50, // Fixed height for the search bar
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.black),
                        SizedBox(width: 10), // Spacing between icon and text
                        Expanded(
                          child: Text(
                            "Search",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Icon(Icons.mic, color: Colors.black),
                        SizedBox(width: 10), // Space between the icons
                        Icon(Icons.cancel_outlined, color: Colors.black), // New icon added
                      ],
                    ),
                  ),
                ),
              ),

              // Another positioned container inside the overlay
              Positioned(
                top: searchBarPosition + 70, // Position the new container below the search bar
                left: 16,
                right: 16,
                child: Container(
                  height: 70, // Height of the second container
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      'Another Container',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Green container placed below the overlay, outside of Stack
          Container(
            height: 100, // Height of the green container
            margin: EdgeInsets.all(16), // Add margin to position it properly
            decoration: BoxDecoration(
              color: Colors.green, // Green color for the container
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                'Green Container',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
