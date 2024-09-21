import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final GestureTapCallback action;
  final String imagePath;
  const CircularIconButton(
      {super.key,
      required this.borderColor,
      required this.backgroundColor,
      required this.action,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: CircleAvatar(
        radius: 26,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: backgroundColor,
          backgroundImage: AssetImage(imagePath),
        ),
      ),
    );
  }
}
