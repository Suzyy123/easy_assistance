import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:flutter/material.dart';
import '../Components/buttons.dart';
import '../Components/textFields.dart';
import '../authServices/AuthServices.dart'; // Your custom AuthServices class

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();
    super.dispose();
  }

  Future<void> register(BuildContext context) async {
    final auth = AuthServices();

    // Check if passwords match
    if (passwordController.text.trim() != confirmpassController.text.trim()) {
      // Show error dialog if passwords do not match
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Password Mismatch"),
          content: const Text("The passwords you entered do not match. Please try again."),
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
      return; // Stop further execution if passwords don't match
    }

    try {
      // Register user with Firebase Authentication
      final userCredential = await auth.signUpWithEmailPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Get the registered user's UID
      final uid = userCredential.user?.uid;

      if (uid != null) {
        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registration Successful!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        throw Exception("User ID not found.");
      }
    } catch (e) {
      // Handle registration errors and Firestore errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Registration Failed"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Register Here",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
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
              // Registration Page Image
              Center(
                child: Image.asset(
                  "assets/images/registerPage.png",
                  height: 200,
                  width: 200,
                ),
              ),
              const SizedBox(height: 20),

              // Username Field
              MyTextfield(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),

              // Email Field
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),

              // Password Field
              MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),

              // Confirm Password Field
              MyTextfield(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmpassController,
              ),
              const SizedBox(height: 20),

              // Forgot Password Link
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

              // Register Button
              Buttons(
                text: "Register",
                onTap: () async => await register(context), // Register on tap
              ),
              const SizedBox(height: 20),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
