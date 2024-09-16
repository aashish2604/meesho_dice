import 'package:flutter/material.dart';

class SocialArea extends StatelessWidget {
  const SocialArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16.0,
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text("data")
          ],
        ),
      ),
      body: Column(
        children: [Text("sometih")],
      ),
    );
  }
}
