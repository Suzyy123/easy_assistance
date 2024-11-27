import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Components/TextField.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Display message for alert
  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  void login(BuildContext context) async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing dialog by tapping outside
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
      displayMessageToUser(
        e.message ?? "An unexpected error occurred. Please try again.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),
        ),
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
              GestureDetector(
                onTap: widget.onTap,
                child: const Padding(
                  padding: EdgeInsets.only(left: 290),
                  child: Text(
                    "New User?",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  "lib/images/google.jpeg",
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController),
              const SizedBox(height: 10),
              MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Implement forgot password functionality here
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => login(context), // Pass to login function
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFF013763),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
