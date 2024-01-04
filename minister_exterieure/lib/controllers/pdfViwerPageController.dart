import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfViwerPageController extends GetxController {
  void showDownloadSuccessDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تحميل الملف'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('تم تحميل الملف بنجاح.'),
                const SizedBox(height: 8.0),
                const Text('يمكنك العثور على الملف في المسار التالي:'),
                const SizedBox(height: 8.0),
                Text(filePath,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('حسنًا'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
