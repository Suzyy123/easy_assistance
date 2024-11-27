import 'package:flutter/material.dart';
class Buttons extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const Buttons({
    super.key,
    required this.text,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF013763),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(text,
          style: TextStyle(
            color: Colors.white, fontSize: 20,
          )
            ),
          
        ),
      ),
    );
  }
}
