import 'package:flutter/material.dart';

class AppTheme {
  ThemeData lightTheme() {
    return ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade700),
        useMaterial3: true);
  }
}
