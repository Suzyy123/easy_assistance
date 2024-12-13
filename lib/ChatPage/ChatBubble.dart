import 'package:flutter/material.dart';
class chatBubble extends StatelessWidget {
  final String message;
  const chatBubble({super.key,
  required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF013763)
      ),
      child: Text(
        message,
        style: const TextStyle(
           fontSize: 16,
          color: Colors.white
        ),
      ),
    );
  }
}
