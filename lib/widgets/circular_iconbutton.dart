import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final GestureTapCallback action;
  const CircularIconButton(
      {super.key,
      required this.borderColor,
      required this.backgroundColor,
      required this.action});

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
        ),
      ),
    );
  }
}
