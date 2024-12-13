import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const Buttons({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[800],
          borderRadius: BorderRadius.circular(200), // Adjusted corner radius
        ),
        padding: const EdgeInsets.all(15), // Reduced padding for smaller size
        margin: const EdgeInsets.symmetric(horizontal: 40), // Adjusted margin
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold// Reduced font size for the text
            ),
          ),
        ),
      ),
    );
  }
}
