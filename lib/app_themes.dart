import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primaryColor: Colors.red,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

final darkTheme = ThemeData(
  primaryColor: Colors.grey.shade900,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.white70,
  ),
);
