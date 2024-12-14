import 'package:easy_assistance_app/authServices/AuthServices.dart';
import 'package:flutter/material.dart';
import '../Components/buttons.dart';
import '../Components/textFields.dart';
import 'forgotPassword.dart';

class Loginpage extends StatefulWidget {
  final void Function()? onTap;

  const Loginpage({super.key, required this.onTap});

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  // Email and password controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    // Get auth service instance
    final authservice = AuthServices();

    // Try login
    try {
      await authservice.signInWithEmailPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // If successful, display success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login Successful!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacementNamed('/home'); // Navigate to Home
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      // If login fails, display error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Login",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white
          ),
          
        ),
        leading: Icon(Icons.arrow_back),
      ),
<<<<<<< HEAD
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Icon(Icons.person, size: 200,)
                ),
                const SizedBox(height: 20),
                // Email Input
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
=======
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/google.jpeg",
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              // Email Input
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              // Password Input
              MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              // Forgot Password
              GestureDetector(
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder:(context){
                   return ForgotPasswordPage();
                 }));
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(decoration: TextDecoration.underline),
>>>>>>> a8c317de50e405dad173f4787debb8b2818ebed1
                ),
                const SizedBox(height: 10),
                // Password Input
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 10),
                // Forgot Password
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
                // Sign In Button
                Buttons(
                  text: "Sign in",
                  onTap: () async => await login(context), // Ensure async call
                ),
                const SizedBox(height: 20),
                // Don't have an account? Register Now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'cursive',
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    try {
                      // Use the AuthServices to sign in with Google
                      await AuthServices().signInWithGoogle();

                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Sign-In Successful!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      // Show error dialog if sign-in fails
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Sign-In Failed"),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Image(
                    image: AssetImage("lib/images/google.jpeg"),
                    width: 80,
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
