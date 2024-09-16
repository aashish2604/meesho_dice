import 'package:flutter/material.dart';

const Color kWhiteColor = Colors.white;
const Color kTranslucentBlack = Colors.black87;
const Color kTransparentColor = Colors.transparent;
const Color kCyan = Colors.cyan;
const Color kSadRed = Color(0xFFB81D24);
const Color kCatsKillWhiteColor = Color(0xFFEEF2F8);
const Color kSmoothBlack = Color.fromARGB(255, 26, 26, 26);
const Color kEggShellColor = Color(0xFFEFE8D8);
const Color kCulturedWhiteColor = Color(0xFFEFE8D8);
const Color kDecoratorWhite = Color(0xFFECEFEC);
const Color kSmokeWhiteColor = Color(0xFFF5F5F5);
const Color kGreyColor = Colors.grey;
const Color kCoffeeColor = Color(0xFF6F4E37);
const Color kChoclateColor = Color(0xFF7B3F00);
const Color kMeeshoPurple = Colors.purple;

const TextStyle bodyTextStyle =
    TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500);

class AppTheme {
  ThemeData lightTheme() {
    return ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        scaffoldBackgroundColor: kCatsKillWhiteColor,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade700),
        useMaterial3: true);
  }
}
