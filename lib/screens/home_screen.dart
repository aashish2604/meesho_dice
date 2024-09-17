import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/virtual_tryon.dart';
import 'package:meesho_dice/screens/model_3d_view.dart';
import 'package:meesho_dice/screens/view_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    File? outputFile;
    return Scaffold(
      appBar: AppBar(
        title: Text("Meesho"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            width: 400,
            child: Image.asset('assets/images/clothes/02_upper.png'),
          ),
          Center(
            child: TextButton(
                onPressed: () async {
                  final apiResponse = await VirtualTryon()
                      .getVirtualTryOnResponse('images/humans/005.png',
                          'images/clothes/02_upper.png')
                      .then((val) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyWidget(file: val!)));
                  });
                },
                child: Text('Virtual try on')),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: outputFile == null
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator())
                : Image.file(outputFile!),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Model3dViewer(
                modelUrl:
                    "https://cdn.tinyglb.com/models/17fbc4482a0e4ae78c6431fb94fc1643.glb",
                modelTitle: "Phone")));
      }),
    );
  }
}
