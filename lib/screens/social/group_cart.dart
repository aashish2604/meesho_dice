import 'package:flutter/material.dart';
import 'package:meesho_dice/services/theme.dart';

class GroupCart extends StatelessWidget {
  const GroupCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Group Cart",
          style: appBarTextStyle,
        ),
      ),
      body: Column(),
    );
  }
}
