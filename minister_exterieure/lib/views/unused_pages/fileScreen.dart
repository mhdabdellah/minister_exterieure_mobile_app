import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FilesScreen extends StatelessWidget {
  final FirebaseStorage _storage = FirebaseStorage.instance;

   FilesScreen({super.key});

  Future<void> downloadFile(String filename, BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final Directory downloadDirectory =
          await getApplicationDocumentsDirectory();
      final File downloadToFile = File('${downloadDirectory.path}/$filename');

      try {
        await _storage.ref('files/$filename').writeToFile(downloadToFile);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download successful!')));
        // Optionally open the file or share it from here
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download file: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Storage permission is required to download files.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Files')),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 4,
        itemBuilder: (context, index) {
          String filename = 'file${index + 1}.pdf';
          return Card(
            child: InkWell(
              onTap: () {
                downloadFile(filename, context);
              },
              child: Center(child: Text('File ${index + 1}')),
            ),
          );
        },
      ),
    );
  }
}
