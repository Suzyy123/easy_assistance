import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Back button
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 16),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous page
                },
              ),
            ),
          ),
          // Diamond icon
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Icon(
                Icons.diamond,
                color: Color(0xFFDAA520),
                size: 130,
              ),
            ),
          ),
          // Main container with text points
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10), // Adjusts the container's position
              child: Container(
                width: 350,
                height: 410, // Increased height to make space for the button
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Premium Features',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Point 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Aligns the text vertically in the center
                            crossAxisAlignment: CrossAxisAlignment.center, // Aligns text to the start (left side)
                            children: [
                              Text(
                                '"unlock exclusive features for a',
                                style: TextStyle(fontSize: 10, color: Colors.black),
                              ),
                              Text(
                                'seamless and ad-free chat experience ' ,
                                style: TextStyle(fontSize: 10, color: Colors.black),
                              ),
                              Text(
                                'with Premium!"',
                                style: TextStyle(fontSize: 10, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 26),
                      // Point 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Virtual Meeting',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Point 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Ad-free experience',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Point 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Exclusive content',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Point 3
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Priority support',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 20), // Reduced height for positioning the button higher
// "Get Premium" Button
                      ElevatedButton(
                        onPressed: () {
                          // Logic to proceed to Premium subscription or features
                        },
                        child: Text('Get Premium', style: TextStyle(fontSize: 16)), // Smaller text size
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDAA520), // Gold color
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Reduced padding for a smaller button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom swipeable containers for plans
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Allows horizontal scrolling
                child: Row(
                  children: [
                    // Weekly Plan
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Lighter shadow color
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Weekly Plan',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$9.99',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    // Monthly Plan
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Lighter shadow color
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Monthly Plan',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$29.99',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    // Annual Plan
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Lighter shadow color
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Annual Plan',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$99.99',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
