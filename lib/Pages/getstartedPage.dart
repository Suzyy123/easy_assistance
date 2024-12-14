import 'package:easy_assistance_app/authServices/AuthGate.dart';
import 'package:flutter/material.dart';
import '../RegisterPages/loginPage.dart';

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
      "image": "lib/images/avatar1.png",
    },
    {
      "title": "Organize Your Tasks",
      "description": "Manage tasks efficiently and prioritize what matters.",
      "image": "lib/images/avatar1.png",
    },
    {
      "title": "Collaborate Seamlessly",
      "description": "Chat, share, and work together with ease.",
      "image": "lib/images/avatar1.png",
    },
    {
      "title": "Track Your Progress",
      "description": "Monitor your goals and achievements.",
      "image": "lib/images/avatar1.png",
    },
  ];

  final TextStyle _titleStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  final TextStyle _descriptionStyle = const TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

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
                      page['image'] ?? 'assets/images/placeholder.png',
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      page['title']!,
                      style: _titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      page['description']!,
                      style: _descriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
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
                if (_currentPage < _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text("Next"),
                  ),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Authgate()),
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
