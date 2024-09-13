import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class Model3dViewer extends StatelessWidget {
  const Model3dViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Damaged Helmet',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 400,
              child: Flutter3DViewer(
                progressBarColor: Colors.blue,
                src: 'assets/models/DamagedHelmet.glb',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
