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
          color: const Color(0xFF013763),
          borderRadius: BorderRadius.circular(8), // Adjusted corner radius
        ),
        padding: const EdgeInsets.all(15), // Reduced padding for smaller size
        margin: const EdgeInsets.symmetric(horizontal: 20), // Adjusted margin
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Reduced font size for the text
            ),
          ),
        ),
      ),
    );
  }
}
