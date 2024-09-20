import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/authenticate/login.dart';
import 'package:meesho_dice/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn
          ? Login(toggleView: toggleView)
          : Register(toggleView: toggleView),
    );
  }
}
