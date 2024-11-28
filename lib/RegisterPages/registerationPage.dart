import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Components/TextField.dart';

class Registerationpage extends StatefulWidget {
  final void Function()? onTap;

  const Registerationpage({super.key, required this.onTap});

    @override
  State<Registerationpage> createState() => _RegisterationpageState();
}

class _RegisterationpageState extends State<Registerationpage> {

  final TextEditingController UsernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmController = TextEditingController();

  @override
  void dispose(){
    UsernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void registerUser() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Ensure passwords match
    if (passwordController.text != ConfirmController.text) {
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match", context);
      return;
    }

    try {
      // Create the user
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Add user details to Firestore
      await addUserDetails(
        UsernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(), // Keeping this per your existing code
      );

      Navigator.pop(context); // Close loading dialog
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      displayMessageToUser(e.code, context);
    }
  }

  void displayMessageToUser(String message, BuildContext context){
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text(message),

        ));
  }

  //data storing
  Future addUserDetails(String Username,String email, String password) async {
    try {
      await FirebaseFirestore.instance.collection("users").add({
        'Username': Username,
        'email': email,
        'password': password,
      });
    }
    catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("          Registration Page"),
        leading: const Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 350,
                  child: Image.asset(
                    "lib/images/registerPage.png",
                  ),
                ),
              ],
            ),
            MyTextfield(hintText: "Username", obscureText: false,
                controller: UsernameController),
            const SizedBox(height: 20),
            MyTextfield(hintText: "Email",
               obscureText: false,
               controller: emailController),
            const SizedBox(height: 20),
           MyTextfield(hintText: "Password",
               obscureText: true,
               controller: passwordController),
            const SizedBox(height: 20),
           MyTextfield(hintText: "Confirm Password",
               obscureText: true,
               controller: ConfirmController),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Login here", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight.bold),)
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: registerUser,
              child: Center(
                child: Container(
                  height: 60,
                  width: 260,
                  decoration: BoxDecoration(
                    color: const Color(0xFF013763),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Register Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        
         SizedBox(height: 6),
         //or sign in with
         Container(
           child: Text("Or sign in with"),
         ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/images/google.jpeg",
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Or",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    "lib/images/google.jpeg",
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Or",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    "lib/images/google.jpeg",
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
