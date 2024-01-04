import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get package or any other state management package.

class ImageScreen extends StatelessWidget {
  final String? imagePath;
  final String imageTitle;

  const ImageScreen(
      {Key? key, required this.imagePath, required this.imageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageTitle),
      ),
      // body: Center(
      //   child: imagePath != null
      //       ? Image.network(
      //           imagePath!, // Use Image.file if the image is from local storage.
      //           fit: BoxFit.cover,
      //         )
      //       : const Text("Image not found"),
      // ),
      body: Center(
        child: imagePath != null
            ? Image.file(
                // Assuming imagePath is a local file path.
                File(imagePath!), // Import 'dart:io' and use File class.
                fit: BoxFit.cover,
              )
            : const Text("Image not found"),
      ),
    );
  }
}
