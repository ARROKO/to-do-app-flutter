import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(background: Colors.grey.shade300,
  primary: Colors.grey.shade200,
  secondary: Colors.grey.shade400,
  inversePrimary: Colors.grey.shade800,  
),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade300,
    ),
    );
