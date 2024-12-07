import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/textFields.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController =TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Password reset link sent! Check your email'),
        );
      });
    }on FirebaseAuthException catch(e){
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
        content: Text(e.message.toString()),
        );
      });
    }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF013763),
        elevation: 0,
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text("Enter your email and we will send you a password reset link",
            textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height:10 ),
          MyTextfield(
            hintText: "Email",
            obscureText: false,
            controller: emailController,
          ),
          SizedBox(height:10 ),
          MaterialButton(
            onPressed: passwordReset ,
            child: Text("Reset Password"),
            color: Color(0xFF013763),// Move `child` property outside the `onPressed` function
          ),

        ],
      )
    );
  }
}
