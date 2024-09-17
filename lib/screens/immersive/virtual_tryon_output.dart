import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/virtual_tryon.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/loading.dart';

class VirtualTryonOutput extends StatelessWidget {
  final String clothImageUrl;
  final File humanImageFile;
  const VirtualTryonOutput(
      {super.key, required this.clothImageUrl, required this.humanImageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Try-on Result",
            style: appBarTextStyle.copyWith(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder(
            future: VirtualTryon().getVirtualTryOnResultFromNetworkAndAsset(
                clothImageUrl, humanImageFile, "Upper body"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LabeledLoadingWidget(
                    label: Text(
                      "Generating...",
                      style: TextStyle(color: Colors.white),
                    ),
                    loaderColor: Colors.white,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data;
                if (data != null) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth, image: FileImage(data))),
                  );
                }
              }
              return const Center(
                child: Text(
                  "Some error occured",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }));
  }
}
