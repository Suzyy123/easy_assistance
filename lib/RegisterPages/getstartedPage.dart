import 'package:flutter/material.dart';
import 'loginPage.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Welcome to Easy Assistance",
      "description": "Your perfect productivity partner.",

    },
    {
      "title": "Organize Your Tasks",
      "description": "Manage tasks efficiently and prioritize what matters.",

    },
    {
      "title": "Collaborate Seamlessly",
      "description": "Chat, share, and work together with ease.",

    },
    {
      "title": "Track Your Progress",
      "description": "Monitor your goals and achievements.",

    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      page['image']!,
                      height: 300,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      page['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      page['description']!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage < _pages.length - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(_pages.length - 1);
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginpage(),
                        ),
                      );
                    },
                    child: const Text("Get Started"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
