import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:minister_exterieure/constant.dart';
import 'package:minister_exterieure/datasources/remote/clients_datasource.dart';
import 'package:minister_exterieure/datasources/remote/downloadsHistorique_datasource.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/errorSnackBar.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/loading.dart';
import 'package:minister_exterieure/views/pdfViwerPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FilesPageController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  late Future<ListResult?> futureFiles;
  bool isFormValid = false;
  bool is_connected = false;
  final TextEditingController passportNumberController =
      TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    futureFiles = listFiles();
  }

  void addPassportNumberDialog(BuildContext context, String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رقم الجواز'),
          content: SingleChildScrollView(
            // Wrapped in SingleChildScrollView
            child: ListBody(
              children: <Widget>[
                const Text('يرجى إدخال رقم الجواز'),
                const SizedBox(height: 8.0),
                FormBuilder(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                      name: 'passport_number',
                      decoration: const InputDecoration(
                        labelText: 'رقم الجواز',
                      ),
                      controller: passportNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم الجواز';
                        }
                        final RegExp pattern = RegExp(r'^[A-Z]\d{8}$');
                        if (!pattern.hasMatch(value)) {
                          return 'يجب أن يتبع رقم الجواز النمط الصحيح (مثال: B12345678)';
                        }
                        return null; // Validation passed
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('الرجوع'),
                onPressed: () async {
                  Navigator.of(context).pop(); // إغلاق الرسالة التحذيرية
                }),
            TextButton(
              child: const Text('حسنًا'),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  try {
                    showLoadingIndicator();
                    DocumentSnapshot<Map<String, dynamic>> clientInfo =
                        await ClientsDataSource().getClientByPassportNumber(
                            passportNumber: passportNumberController.text);
                    // final firestore = FirebaseFirestore.instance;
                    // DocumentSnapshot<Map<String, dynamic>> clientInfo =
                    //     await firestore
                    //         .collection('clients')
                    //         .doc(passportNumberController.text)
                    //         .get();
                    if (clientInfo.exists) {
                      await DownloadHistoriqueDataSource()
                          .addDownloadHystorique(
                        fileName: fileName,
                        passportNumber: passportNumberController.text,
                      );
                      // await firestore
                      //     .collection('historique_telechargements')
                      //     .add({
                      //   'le_fichier_telechargee': fileName,
                      //   'passport_number': passportNumberController.text,
                      // });
                      await openPdf(fileName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'غير مسجل لدي القنصلية، فم بالتسجيل لتتمكن من تنزيل المستندات'),
                        ),
                      );
                      Get.back();
                    }
                  } catch (e) {
                    // Handle the error properly
                    Get.back();
                  }
                  // Get.back();
                  // Navigator.of(context).pop(); // Pop the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الرجاء تصحيح الأخطاء في النموذج'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<ListResult?> listFiles() async {
    is_connected = await checkConnectivity();

    if (await checkConnectivity()) {
      // Adjust the path as needed
      ListResult results =
          await FirebaseStorage.instance.ref('files').listAll();
      update();
      return results;
    } else {
      errorSnackBar(
          message: 'لا يوجد اتصال ببيانات الهاتف المحمول أو شبكة الواي فاي.');
      update();
      return null;
    }
  }

  Future<void> openPdf(String fileName) async {
    dismissLoadingIndicator();
    // Navigator.of(context).pop();
    Get.back();
    showLoadingIndicator();
    try {
      if (await checkConnectivity()) {
        // Assuming your files are directly in the "files/" directory in Firebase Storage
        final url = await FirebaseStorage.instance
            .ref('files/$fileName')
            .getDownloadURL();
        final localPath = await downloadFile(url, fileName);

        // Navigate to the PDFScreen
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) =>
        //       PDFScreen(filePath: localPath, fileTitle: fileName),
        // ));
        // dismissLoadingIndicator();

        Get.to(() => PDFScreen(filePath: localPath, fileTitle: fileName));
        // successSnackBar(
        //     message: " تم تحميل الملف بنجاح سوف تجده في التنزيلات.");
        // showDownloadSuccessDialog(context, localPath ?? "");
      } else {
        dismissLoadingIndicator();
        errorSnackBar(
            message: 'لا يوجد اتصال ببيانات الهاتف المحمول أو شبكة الواي فاي.');
      }
    } catch (e) {
      dismissLoadingIndicator();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل الملف: $e')),
      );
    }
  }
  // Download the file

  Future<String> downloadFile(String url, String fileName) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = '$url/$fileName';
      if (await checkConnectivity()) {
        var request = await httpClient.getUrl(Uri.parse(myUrl));
        var response = await request.close();
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          filePath = '/storage/emulated/0/Download/$fileName';
          file = File(filePath);
          await file.writeAsBytes(bytes);
          dismissLoadingIndicator();
        } else {
          filePath = 'Error code: ${response.statusCode}';
        }
      } else {
        dismissLoadingIndicator();
        errorSnackBar(
            message: 'لا يوجد اتصال ببيانات الهاتف المحمول أو شبكة الواي فاي.');
      }
    } catch (e) {
      filePath = 'Can not fetch url';
      print('Error downloading file: $e');
      dismissLoadingIndicator();
      errorSnackBar(message: 'خطأ في تحميل الملف.');
    }

    return filePath;
  }

  Future<String?> downloadPDF(String url, String fileName) async {
    // Check and request the storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      await getExternalStorageDirectory();
      if (!status.isGranted) {
        // Permission denied, return or show error
        print('Storage permission denied');
        dismissLoadingIndicator();
        errorSnackBar(message: 'تم رفض إذن الوصول إلى التخزين.');
        return null;
      }
    }

    // Get the reference from the URL
    final Reference ref = FirebaseStorage.instance.refFromURL(url);

    // Get the system downloads directory path
    String? dirPath;
    try {
      if (Platform.isAndroid) {
        dirPath = '/storage/emulated/0/Download';
      } else {
        // For iOS, you can't directly download to the system's downloads folder.
        // You'll have to use getApplicationDocumentsDirectory or present a share sheet.
        dirPath = (await getApplicationDocumentsDirectory()).path;
      }
    } on UnsupportedError {
      // Platform not supported
      return null;
    }

    // Full file path
    final String fullPath = '$dirPath/$fileName';
    final File file = File(fullPath);

    // Download the file
    try {
      if (await checkConnectivity()) {
        await ref.writeToFile(file);
        print('File downloaded to $fullPath');
        // showDownloadSuccessDialog(context, fullPath ?? "");
        // successSnackBar(
        //     message: " تم تحميل الملف بنجاح سوف تجده في التنزيلات.");
        dismissLoadingIndicator();

        return fullPath;
      } else {
        dismissLoadingIndicator();
        errorSnackBar(
            message: 'لا يوجد اتصال ببيانات الهاتف المحمول أو شبكة الواي فاي.');
        return null;
      }
    } catch (e) {
      // Handle errors on download
      print('Error downloading file: $e');
      dismissLoadingIndicator();
      errorSnackBar(message: 'خطأ في تحميل الملف.');
      return null;
    }
    return null;
  }

  // Future<String> downloadPDF(String url, String fileName) async {
  //   final Reference ref = FirebaseStorage.instance.refFromURL(url);
  //   final Directory dir = await getApplicationDocumentsDirectory();
  //   final File file = File('${dir.path}/$fileName');
  //   await ref.writeToFile(file);
  //   return file.path;
  // }
}
