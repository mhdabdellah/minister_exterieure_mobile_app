import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:minister_exterieure_mobile_app/constant.dart';
import 'package:minister_exterieure_mobile_app/controllers/filesPageController.dart';
import 'package:minister_exterieure_mobile_app/views/customWidgets/dialog/errorSnackBar.dart';
import 'package:minister_exterieure_mobile_app/views/splashScreen/splashScreen.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('تسهيل'),
            Image.asset('assets/logo.png', height: 40),
          ],
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: GetBuilder<FilesPageController>(
          init: FilesPageController(),
          builder: (filesPageController) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'الوثائق',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                filesPageController.is_connected
                    ? Expanded(
                        child: FutureBuilder<ListResult?>(
                          future: filesPageController.futureFiles,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemCount: snapshot.data!.items.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      filesPageController.is_connected =
                                          await checkConnectivity();
                                      setState(() {});
                                      if (filesPageController.is_connected) {
                                        filesPageController
                                            .addPassportNumberDialog(
                                                context,
                                                snapshot
                                                    .data!.items[index].name);
                                      } else {
                                        errorSnackBar(
                                            message: "لا توجد إنترنت");
                                      }
                                      // if(passportNubmerAdded){
                                      //   openPdf(context, snapshot.data!.items[index].name);

                                      // }
                                    },
                                    child: GridTile(
                                      header: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data!.items[index].name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.insert_drive_file,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            return const Center(child: Text('لا توجد ملفات.'));
                          },
                        ),
                      )
                    : Expanded(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.offAll(() => const SplashScreen());
                              },
                              icon: const Icon(
                                Icons.refresh,
                                size: 50,
                              )),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text('لا توجد إنترنت'),
                        ],
                      )),
                // Footer Container
                Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 234, 191, 51),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/rim_drp.jpg', // Replace with your asset image
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'يمكنك الآن تحميل الوثائق بعد تفعيل الحساب',
                        style: TextStyle(
                          color: Color(0xFF00A95C),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
