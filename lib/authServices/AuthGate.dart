import 'package:easy_assistance_app/ProfilePage/ProfileMain.dart';
import 'package:easy_assistance_app/Pages/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ChatPage/ChatPageUI.dart';
import '../auth/login_or_register.dart';
class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
        //user logged in
            if(snapshot.hasData){
              return const ChatPage();
            }
            //user is not logged in
            else{
              return const LoginOrRegister();
            }
          },
      ),
    );
  }
}
