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
import 'Pages/getstartedPage.dart';
import 'Pages/homePage.dart'; // Your home page
import 'ProfilePage/ProfileMain.dart';
import 'RegisterPages/loginPage.dart';
import 'Todo_task/frontPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart'; // Import Firebase Dynamic Links
import 'package:easy_assistance_app/Todo_task/AcceptDenyPage.dart';

import 'Todo_task/links/dynamic_link_handler.dart';
import 'authServices/AuthServices.dart';

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
  final DynamicLinkHandler _dynamicLinkHandler = DynamicLinkHandler(); // Create an instance of DynamicLinkHandler

  @override
  void initState() {
    super.initState();
    //_initDynamicLinks();
    _dynamicLinkHandler.initDynamicLinks(context); // Initialize dynamic links
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: GetStartedPage() // Or your desired starting page
    );
  }
}
