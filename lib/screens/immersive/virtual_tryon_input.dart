import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/immersive/virtual_tryon_output.dart';
import 'package:meesho_dice/services/theme.dart';

class VirtualTryOnInput extends StatefulWidget {
  final String clothImage;
  const VirtualTryOnInput({super.key, required this.clothImage});

  @override
  State<VirtualTryOnInput> createState() => _VirtualTryOnInputState();
}

class _VirtualTryOnInputState extends State<VirtualTryOnInput> {
  File? humanImage;

  Future selectHumanImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        humanImage = File(result.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Virtual Try-on",
          style: appBarTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: CachedNetworkImageProvider(widget.clothImage))),
            ),
            const SizedBox(
              height: 12.0,
            ),
            humanImage == null
                ? TextButton.icon(
                    onPressed: selectHumanImage,
                    style: TextButton.styleFrom(backgroundColor: Colors.purple),
                    label: Text(
                      "Add you image",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  )
                : HumanImageWidgets(
                    humanImage: humanImage!,
                    clothImageUrl: widget.clothImage,
                  )
          ],
        ),
      ),
    );
  }
}

class HumanImageWidgets extends StatelessWidget {
  final File humanImage;
  final String clothImageUrl;
  const HumanImageWidgets(
      {super.key, required this.humanImage, required this.clothImageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.add),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: 300,
          width: double.infinity,
          child: Image.file(
            humanImage,
            fit: BoxFit.fitHeight,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VirtualTryonOutput(
                        clothImageUrl: clothImageUrl,
                        humanImageFile: humanImage,
                      )));
            },
            style: TextButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text(
              "Get Results",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
