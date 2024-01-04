import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:minister_exterieure/controllers/pDFUploadScreenController.dart';

class PDFUploadScreen extends StatefulWidget {
  const PDFUploadScreen({super.key});

  @override
  _PDFUploadScreenState createState() => _PDFUploadScreenState();
}

class _PDFUploadScreenState extends State<PDFUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قنصليتي"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/logo.png'), // Your logo asset path
          ),
        ],
      ),
      body: GetBuilder<PDFUploadScreenController>(
          init: PDFUploadScreenController(),
          builder: (pDFUploadScreenController) {
            return Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: pDFUploadScreenController.selectFile,
                    child: const Text('اختر الوثيقة'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: pDFUploadScreenController.uploadFile,
                    child: const Text('رفع الوثيقة'),
                  ),
                  const SizedBox(height: 20),
                  if (pDFUploadScreenController.task != null)
                    pDFUploadScreenController
                        .buildUploadStatus(pDFUploadScreenController.task!),
                ],
              ),
            );
          }),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 234, 191, 51),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/rim_drp.jpg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'إختر الوثيقة ثم إرفعها علي التطبيق',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
