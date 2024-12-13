import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:flutter/material.dart';
import '../Components/buttons.dart';
import '../Components/textFields.dart';
import '../authServices/AuthServices.dart';
import 'forgotPassword.dart'; // Your custom AuthServices class

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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Text("Register Here", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
              // Registration Page Image
              Center(
                child: Image.asset(
                  "lib/images/registerPage.png",
                  height: 220,
                ),
              ),
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
              const SizedBox(height: 15),
              // Forgot Password Link
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()), // Add parentheses
                  );
                },
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),

              const SizedBox(height: 15),

              // Register Button
              Buttons(
                text: "Register",
                onTap: () async => await register(context), // Register on tap
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the images horizontally
                children: [
                  // Google sign-in image with GestureDetector
                  GestureDetector(
                    onTap: () async {
                      try {
                        // Use the AuthServices to sign in with Google
                        await AuthServices().registerWithGoogle();

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
                    child: ClipOval(
                      child: Image.asset(
                        "lib/images/google.jpeg",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Add spacing between images

                  // First additional circular image
                  // ClipOval(
                  //   child: Image.asset(
                  //     "lib/images/google.jpeg", // Replace with the actual path to your second image
                  //     width: 60,
                  //     height: 60,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // const SizedBox(width: 20), // Add spacing between images
                  //
                  // // Second additional circular image
                  // ClipOval(
                  //   child: Image.asset(
                  //     "lib/images/google.jpeg", // Replace with the actual path to your third image
                  //     width: 60,
                  //     height: 60,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ],
              )


            ],
          ),
        ),
      ),
    );
  }
}
