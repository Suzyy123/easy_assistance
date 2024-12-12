import 'package:easy_assistance_app/ProfilePage/ProfileMain.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ChatPage/ChatPageUI.dart';
import '../Pages/homePage.dart';
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
            return HomePage();
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
