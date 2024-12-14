import 'package:flutter/material.dart';
ThemeData lightMode = ThemeData(
<<<<<<< HEAD
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary:  Colors.grey.shade200,
    secondary:  Colors.grey.shade400,
        inversePrimary: Colors.grey.shade800
    ),
   textTheme: ThemeData.light().textTheme.apply(
     bodyColor: Colors.grey[800],
     displayColor: Colors.black
   )

=======
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary:  Colors.grey.shade500,
    secondary:  Colors.grey.shade200,
    tertiary:  Colors.white,
    inversePrimary: Colors.grey.shade900
  )
>>>>>>> a8c317de50e405dad173f4787debb8b2818ebed1
);