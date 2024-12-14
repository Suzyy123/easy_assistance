import 'package:easy_assistance_app/authServices/AuthGate.dart';
import 'package:easy_assistance_app/firebase_options.dart';
import 'package:easy_assistance_app/themes/lightMode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
=======


import 'ChatPage/ChatBubble.dart';
import 'ChatPage/ChatPageUI.dart';
import 'ChatPage/Message.dart';
import 'ChatPage/Messenger.dart';
import 'ChatPage/chatListPage.dart';

>>>>>>> a8c317de50e405dad173f4787debb8b2818ebed1

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Authgate(),
      theme: lightMode,
    );
  }
}

