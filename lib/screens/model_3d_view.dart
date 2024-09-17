import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:meesho_dice/services/theme.dart';

class Model3dViewer extends StatelessWidget {
  final String modelUrl;
  final String modelTitle;
  const Model3dViewer(
      {super.key, required this.modelUrl, required this.modelTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Immersive Zone",
          style: appBarTextStyle,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: Flutter3DViewer(
                  progressBarColor: Colors.purple,
                  src: modelUrl,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  modelTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
