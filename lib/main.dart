import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/home_page.dart';
import 'package:meesho_dice/screens/home_screen.dart';
import 'package:meesho_dice/services/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme(),
      home: const HomePage(),
    );
  }
}
