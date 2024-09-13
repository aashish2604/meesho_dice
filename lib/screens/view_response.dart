import 'dart:io';

import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final File file;
  const MyWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 400,
          width: 400,
          child: Image.file(file),
        ),
      ),
    );
  }
}
