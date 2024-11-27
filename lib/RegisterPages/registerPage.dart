import 'package:easy_assistance_app/authServices/AuthServices.dart';
import 'package:flutter/material.dart';
import '../Components/buttons.dart';
import '../Components/textFields.dart';

class Registerpage extends StatefulWidget {
  final void Function()? onTap;

  Registerpage({super.key, required this.onTap});

  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
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
    // Get auth service instance
    final auth = AuthServices();

    // Check if passwords match
    if (passwordController.text.trim() == confirmpassController.text.trim()) {
      try {
        // Register user
        await auth.signUpWithEmailPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        // Display success message or navigate
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
              )
            ],
          ),
        );
      } catch (e) {
        // Handle registration errors
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
    } else {
      // Show error dialog when passwords do not match
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Password Mismatch"),
          content: const Text(
              "The passwords you entered do not match. Please try again."),
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
      appBar: AppBar(
        title: const Text(
          "Register Here",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
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
              Center(
                child: Image.asset(
                  "lib/images/registerPage.png",
                  height: 300,
                  width: 300,
                ),
              ),
              const SizedBox(height: 20),
              // Username
              MyTextfield(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),
              // Email
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              // Password
              MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              // Confirm Password
              MyTextfield(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmpassController,
              ),
              const SizedBox(height: 20),
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
                onTap: () async => await register(context), // Ensure async call
              ),
              const SizedBox(height: 20),
              // Already have an account? Login Now
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
