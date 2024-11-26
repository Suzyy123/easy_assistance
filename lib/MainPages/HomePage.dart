import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  //log out logic
  void logout(){
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.yellow,
  title: Text("Home Page"),
  actions: [
    IconButton(onPressed: logout,
        icon: Icon(Icons.logout))
  ],
),
    );
  }
}
