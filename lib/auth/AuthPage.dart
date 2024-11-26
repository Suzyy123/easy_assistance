import 'package:easy_assistance_app/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../MainPages/HomePage.dart';
class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            //user is logged in
            if(snapshot.hasData){
              return const Homepage();
            }
            //user is not logged in
            else{
              return const LoginOrRegister();
            }
          }
          ),
    );
  }
}
