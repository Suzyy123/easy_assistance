import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              height: 100,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Custom Box',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
