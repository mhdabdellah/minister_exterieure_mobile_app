import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PassportPhotoPage extends StatefulWidget {
  const PassportPhotoPage({super.key});

  @override
  _PassportPhotoPageState createState() => _PassportPhotoPageState();
}

class _PassportPhotoPageState extends State<PassportPhotoPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // Handle the case when no image is selected.
      }
    });
  }

  Future<void> _selectPicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // Handle the case when no image is selected.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passport Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!, width: 150, height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('Take Picture'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _selectPicture,
                  child: const Text('Select Picture'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
