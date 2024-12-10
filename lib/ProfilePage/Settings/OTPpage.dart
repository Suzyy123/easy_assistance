import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';

import 'ResetPassword.dart';

class SendAndVerifyOTPPage extends StatefulWidget {
  @override
  _SendAndVerifyOTPPageState createState() => _SendAndVerifyOTPPageState();
}

class _SendAndVerifyOTPPageState extends State<SendAndVerifyOTPPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final EmailOTP emailOtp = EmailOTP();

  bool isOTPSent = false;

  void sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    emailOtp.setConfig(
      appEmail: "yourappemail@example.com", // Replace with your sender email
      appName: "Your App Name", // Replace with your app name
      userEmail: emailController.text.trim(),
      otpLength: 6,
    );

    bool result = await emailOtp.sendOTP();
    if (result) {
      setState(() {
        isOTPSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to ${emailController.text.trim()}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  void verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    bool isValid = await emailOtp.verifyOTP(otp: otpController.text.trim());
    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verified!')),
      );

      // Navigate to the next page (e.g., ForgotPasswordPage)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send and Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Input
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
              enabled: !isOTPSent,
            ),
            SizedBox(height: 20),

            // OTP Input
            if (isOTPSent)
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            if (isOTPSent) SizedBox(height: 20),

            // Button
            ElevatedButton(
              onPressed: isOTPSent ? verifyOtp : sendOtp,
              child: Text(isOTPSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
