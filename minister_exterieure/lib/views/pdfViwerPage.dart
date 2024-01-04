import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minister_exterieure/controllers/pdfViwerPageController.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/successSnackBar.dart';
import 'package:minister_exterieure/views/splashScreen/splashScreen.dart';
import 'package:document_viewer/document_viewer.dart';

class PDFScreen extends StatefulWidget {
  const PDFScreen({Key? key, required this.filePath, required this.fileTitle})
      : super(key: key);

  final String? filePath;
  final String fileTitle;

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              widget.fileTitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 6),
              // style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // const SizedBox(width: 10), // Spacing between text and logo
          Image.asset('assets/logo.png', height: 30), // Include your logo asset
        ],
      )),
      body: widget.filePath != null
          ? GetBuilder<PdfViwerPageController>(
              init: PdfViwerPageController(),
              builder: (pdfViwerPageController) {
                return Column(
                  children: [
                    // Expanded(
                    //   child: PDFView(
                    //     filePath: widget.filePath,
                    //     //         filePath: url,
                    //     autoSpacing: true,
                    //     enableSwipe: true,
                    //     pageSnap: true,
                    //     swipeHorizontal: true,
                    //     nightMode: false,
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: DocumentViewer(filePath: widget.filePath!),
                      ),
                    ),
                    Center(
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                            successSnackBar(
                                message:
                                    " تم تحميل الملف بنجاح سوف تجده في التنزيلات.");
                            pdfViwerPageController.showDownloadSuccessDialog(
                                context, widget.filePath ?? "");
                          },
                          icon: const Icon(
                            Icons.download,
                            size: 40,
                          )),
                    )
                  ],
                );
              })
          : const SplashScreen(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PDFViewPage extends StatelessWidget {
//   final String url;

//   PDFViewPage(this.url);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: PDFView(
//         filePath: url,
//         autoSpacing: true,
//         enableSwipe: true,
//         pageSnap: true,
//         swipeHorizontal: true,
//         nightMode: false,
//       ),
//     );
//   }
// }
