import 'package:easy_assistance_app/Pages/getstartedPage.dart';
import 'package:easy_assistance_app/Todo_task/All_Notes.dart';
import 'package:easy_assistance_app/authServices/AuthGate.dart';
import 'package:easy_assistance_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ChatPage/ChatBubble.dart';
import 'ChatPage/ChatPageUI.dart';
import 'ChatPage/Message.dart';
import 'ChatPage/Messenger.dart';
import 'ChatPage/chatListPage.dart';
import 'Pages/homePage.dart'; // Your home page
import 'ProfilePage/ProfileMain.dart';
import 'Todo_task/DocsPage.dart';
import 'Todo_task/Meeting.dart';
import 'Todo_task/MeetingPage.dart';
import 'Todo_task/frontPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart'; // Import Firebase Dynamic Links
import 'package:easy_assistance_app/Todo_task/AcceptDenyPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initDynamicLinks();
  }

  void _initDynamicLinks() async {
    // Handle dynamic links when the app is resumed
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLink) {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('Received dynamic link: $deepLink');
        if (deepLink.queryParameters.containsKey('meetingId')) {
          String meetingId = deepLink.queryParameters['meetingId']!;
          print('Extracted meetingId: $meetingId');

          // Navigate to the AcceptDenyPage with the meetingId from the dynamic link
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AcceptDenyPage(meetingId: meetingId),
            ),
          );
        } else {
          print('Dynamic link does not contain a meetingId parameter. Navigating to HomePage.');
          // Navigate to HomePage if no meetingId is present
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(), // Update HomePage with your actual home page widget
            ),
          );
        }
      } else {
        print('No deep link found. Navigating to HomePage.');
        // Navigate to HomePage if no deep link is found
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // Update HomePage with your actual home page widget
          ),
        );
      }
    }).onError((error) {
      print('Error in dynamic link: $error. Navigating to HomePage.');
      // Navigate to HomePage if an error occurs
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(), // Update HomePage with your actual home page widget
        ),
      );
    });

    // Handle dynamic links when the app is initially opened
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = initialLink?.link;

    if (deepLink != null) {
      print('Initial deep link: $deepLink');
      if (deepLink.queryParameters.containsKey('meetingId')) {
        String meetingId = deepLink.queryParameters['meetingId']!;
        print('Extracted meetingId from initial link: $meetingId');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcceptDenyPage(meetingId: meetingId),
          ),
        );
      } else {
        print('Initial link does not contain a meetingId parameter. Navigating to HomePage.');
        // Navigate to HomePage if no meetingId is present in the initial link
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // Update HomePage with your actual home page widget
          ),
        );
      }
    } else {
      print('No initial deep link found. Navigating to HomePage.');
      // Navigate to HomePage if no deep link is found at launch
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(), // Update HomePage with your actual home page widget
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: GetStartedPage(), // Or your desired starting page
    );
  }
}
