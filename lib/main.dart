
import 'package:easy_assistance_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

import 'Todo_task/NotificationList.dart';
import 'Todo_task/TaskListDropdown.dart';
import 'Todo_task/TaskListPage.dart';
import 'Todo_task/TodoTask.dart';
import 'Todo_task/addpage.dart';
import 'Todo_task/createPage.dart';
import 'Todo_task/default.dart';
import 'Todo_task/delete.dart';
import 'Todo_task/dropdown.dart';
import 'Todo_task/frontPage.dart';
import 'Todo_task/personal.dart';
import 'Todo_task/shopping.dart';
import 'Todo_task/shoppingService.dart';
import 'Todo_task/Lists_New.dart';
import 'package:flutter/material.dart';
import 'Todo_task/notification_icon.dart';
import 'Todo_task/NotificationHome.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //FirebaseMessaging messaging = FirebaseMessaging.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: TodoApp(),
          home:  NotificationHome(),
    );
  }
}


