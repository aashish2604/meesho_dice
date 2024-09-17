import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class VirtualTryon {
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File?> getVirtualTryOnResponse(
      String humanPicPath, String clothPicPath) async {
    File humanImage = await getImageFileFromAssets(humanPicPath);
    File clothImage = await getImageFileFromAssets(clothPicPath);
    List<int> humanImageBytes = await humanImage.readAsBytes();
    String humanBase64Image = base64Encode(humanImageBytes);
    List<int> clothImageBytes = await clothImage.readAsBytes();
    String clothBase64Image = base64Encode(clothImageBytes);

    String apiKey = "SG_0b90dcdec4d75776";
    String url = "https://api.segmind.com/v1/try-on-diffusion";

    // Prepare the data for API request
    Map<String, dynamic> data = {
      "model_image": humanBase64Image,
      "cloth_image": clothBase64Image, // Replace with actual cloth image base64
      "category": "Upper body",
      "num_inference_steps": 35,
      "guidance_scale": 2,
      "seed": 5858695741,
      "base64": false
    };

    try {
      // Make the API request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        Directory tempDir = await getTemporaryDirectory();
        String outputFilePath = '${tempDir.path}/api_image.jpg';
        File file = File(outputFilePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null;
  }

  Future<String> toB64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return base64Encode(bytes);
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<File?> getVirtualTryOnResultFromNetworkAndAsset(
      String clothImageUrl, File humanImageFile, String category) async {
    List<int> humanImageBytes = await humanImageFile.readAsBytes();
    String humanImageBase64 = base64Encode(humanImageBytes);
    String clothImageBase64 = await toB64(clothImageUrl);

    String apiKey = "SG_0b90dcdec4d75776";
    String url = "https://api.segmind.com/v1/try-on-diffusion";

    // Prepare the data for API request
    Map<String, dynamic> data = {
      "model_image": humanImageBase64,
      "cloth_image": clothImageBase64, // Replace with actual cloth image base64
      "category": category,
      "num_inference_steps": 35,
      "guidance_scale": 2,
      "seed": 5858695741,
      "base64": false
    };

    try {
      // Make the API request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        Directory tempDir = await getTemporaryDirectory();
        String outputFilePath = '${tempDir.path}/api_image.jpg';
        File file = File(outputFilePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null;
  }
}
