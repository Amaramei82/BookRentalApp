import 'package:flutter/material.dart';
import 'package:book_rental_system/theme/color.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: darkGreen,
  scaffoldBackgroundColor: white,
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: darkGreen),
    labelLarge: TextStyle(color: white, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkGreen,
      foregroundColor: white,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: lightGreen),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: darkGreen),
    ),
  ),
);
