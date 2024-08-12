import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.grey.shade800,
  ),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1F1D2B),
    primary: Color(0xFF272635),
    secondary: Color(0xFF6F6FC8),
    inversePrimary: Color(0xFFFCFCFC),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFFFCFCFC),
  ),
);

ThemeData mode1 = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF1E5D1),
    primary: Color(0xFFDBB5B5),
    secondary: Color(0xFFC39898),
    inversePrimary: Color(0xFFFFFFFF),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFFFFFFFF),
  ),
);

ThemeData greyMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
  ),
);
