import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Components/TextField.dart';
class Loginpage extends StatelessWidget {
   final void Function()? onTap;
   Loginpage({super.key, required this.onTap, });

   final TextEditingController emailController = TextEditingController();
   final TextEditingController passwordController = TextEditingController();
//display meesage for alert
   void displayMessageToUser(String message, BuildContext context){
     showDialog(context: context,
         builder: (context) => AlertDialog(
           title: Text(message),
         ));
   }
   void login(BuildContext context) async {
     // Show loading circle
     showDialog(
       context: context,
       builder: (context) => const Center(
         child: CircularProgressIndicator(),
       ),
     );
     try {
       // Attempt to log in
       await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: emailController.text.trim(),
         password: passwordController.text.trim(),
       );

       // Pop loading circle if login is successful
       if (context.mounted) Navigator.pop(context);
     } on FirebaseAuthException catch (e) {
       // Pop loading circle and show error message
       Navigator.pop(context);
       displayMessageToUser(e.code, context); // Fixed missing semicolon
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("                 Login ", style: TextStyle(
          fontSize: 26, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal
        ),
        ),
        leading: Icon(Icons.arrow_back,),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 290),
              child: Text("New User?",
              style: TextStyle(
                decoration: TextDecoration.underline
              ),
              ),
            ),
          ),
          Container(

            child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("lib/images/google.jpeg"),
                ],
              ),


            ),
         MyTextfield(hintText: "Email",
             obscureText: false, controller: emailController),
          SizedBox(height: 10,),
         MyTextfield(hintText: "Password",
             obscureText: true,
             controller: passwordController),
        SizedBox(height: 10),
        GestureDetector(
          onTap: (){},
          child: Container(
            child: Text("forgot password?", style: TextStyle(decoration: TextDecoration.underline),),
          ),
        ),
          SizedBox(height: 20,),
          Center(
            child: GestureDetector(
              onTap: () => login(context),//pass to login function
              child: Container(
                height: 60,
                width: 260,
               decoration: BoxDecoration(
                 color: Color(0xFF013763),
                 borderRadius: BorderRadius.circular(10)
               ),
              child: Center(child: Text("Sign in", style: TextStyle(color: Colors.white),),

              ),
              ),
            ),

          )
        ],
      ),
    );
  }
}

