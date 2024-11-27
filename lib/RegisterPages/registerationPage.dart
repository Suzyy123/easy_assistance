import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Components/TextField.dart';

class RegistrationPage extends StatefulWidget {
  final void Function()? onTap;

  const RegistrationPage({super.key, required this.onTap});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void registerUser() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Ensure passwords match
    if (passwordController.text != confirmController.text) {
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match", context);
      return;
    }

    try {
      // Register user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Add user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
      });

      Navigator.pop(context); // Close loading dialog
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      displayMessageToUser(e.message ?? "An error occurred", context);
    }
  }

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Image.asset(
                  "lib/images/registerPage.png",
                ),
              ),
              const SizedBox(height: 20),
              MyTextfield(
                  hintText: "Username", obscureText: false, controller: usernameController),
              const SizedBox(height: 20),
              MyTextfield(
                  hintText: "Email", obscureText: false, controller: emailController),
              const SizedBox(height: 20),
              MyTextfield(
                  hintText: "Password", obscureText: true, controller: passwordController),
              const SizedBox(height: 20),
              MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmController),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: registerUser,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF013763),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Register Now",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Or sign in with"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {}, // Add your Google sign-in logic here
                    child: Image.asset(
                      "lib/images/google.jpeg",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {}, // Add your Facebook sign-in logic here
                    child: Image.asset(
                      "lib/images/facebook.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {}, // Add your Apple sign-in logic here
                    child: Image.asset(
                      "lib/images/apple.png",
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
