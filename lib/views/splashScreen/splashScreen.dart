import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minister_exterieure_mobile_app/constant.dart';
import 'package:minister_exterieure_mobile_app/views/customWidgets/dialog/errorSnackBar.dart';
import 'package:minister_exterieure_mobile_app/views/filesPage.dart';
import 'package:minister_exterieure_mobile_app/views/userinfo_in_setps.dart';
// import 'package:minister_exterieure_mobile_app/views/userinfo_in_setps.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () async {
      // statusDialog();
      if (await checkConnectivity()) {
        // Get.offAll(() => const RegisterClientForm());
        // Get.offAll(() => const UserInfoSteper());
        // Get.to(() => const FilesPage());
        // Get.to(() => statusDialog());
        statusDialog();
        // statusDialog(context);
        // ()
      } else {
        errorSnackBar(
            message: 'لا يوجد اتصال ببيانات الهاتف المحمول أو شبكة الواي فاي.');
        Get.offAll(() => const SplashScreen());
      }
    });
  }

  void statusDialog() {
    if (Get.context == null) {
      print("Get.context is null");
      return; // Handle this scenario appropriately
    }

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text('الحالة'),
        content: const SingleChildScrollView(
          // Added SingleChildScrollView for scrolling
          child: ListBody(
            children: <Widget>[
               Image(
                // image: AssetImage('assets/dem.png'),
                image: AssetImage('assets/logo.png'),
                width: 100,
                height: 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                   Text(
                    'ماهي حالتك',
                    style: const TextStyle(
                        fontSize: 25.0, // Choose the size that fits your needs
                        fontWeight: FontWeight.bold), // Styling the text
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                  double.infinity, 36), // double.infinity is the key here
            ),
            child: const Text('جديد'),
            onPressed: () {
              Get.to(() =>
                  const UserInfoSteper()); // Assuming UserInfoSteper is a properly defined widget
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                  double.infinity, 36), // double.infinity is the key here
            ),
            child: const Text('مسجل'),
            onPressed: () {
              Get.to(() =>
                  const FilesPage()); // Assuming FilesPage is a properly defined widget
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('تسهيل'),
            // const SizedBox(width: 10), // Spacing between text and logo
            Image.asset('assets/logo.png',
                height: 40), // Include your logo asset
          ],
        ),
        // const Text("تسهيل"),
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Image.asset('assets/logo.png'), // Your logo asset path
        //   ),
        // ],
      ),
      body: Center(
        child: Container(
            // margin: EdgeInsets.only(bottom: 40.0),
            margin: const EdgeInsets.only(bottom: 20.0, top: 200.0),
            // width: 100,
            // height: 100,
            child: Column(
              children: [
                const Image(
                  // image: AssetImage('assets/dem.png'),
                  image: AssetImage('assets/logo.png'),
                  width: 200,
                  height: 200,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Text(
                    //   // "Don".tr,
                    //   "تسهيل",
                    //   style: TextStyle(
                    //       fontSize: 28,
                    //       color: Colors.blue,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    Text(
                      'القنصلية العامة لموريتانيا بالدار البيضاء',
                      style: TextStyle(
                          fontSize:
                              25.0, // Choose the size that fits your needs
                          fontWeight: FontWeight.bold), // Styling the text
                      textAlign: TextAlign.center,
                    ),
                    // Text(
                    //   // "App".tr,
                    //   "يتي",
                    //   style: TextStyle(
                    //       fontSize: 28,
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold),
                    // ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
