import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void successSnackBar({required String message}) {
  Get.snackbar(
    // 'Réussi !'.tr,
    '',
    '',
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color.fromARGB(255, 244, 229, 224),
    messageText: Row(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Lottie.asset("assets/animated_icons/successfully.json"),
        ),
        Expanded(
          // This will ensure the text takes up the remaining space
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0), // Add some padding between the icon and the text
            child: Text(
              message.tr,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16, // Consider adding a font size if you haven't
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow with ellipsis
            ),
          ),
        ),
      ],
    ),
    colorText: Colors.green,
    // boxShadows: [
    //   BoxShadow(
    //     color: Colors.black.withOpacity(0.1),
    //     offset: const Offset(1, 1),
    //     blurRadius: 10,
    //   ),
    // ],
    margin: const EdgeInsets.all(10), // Add margins if needed
    borderRadius: 10, // Round the corners if desired
    duration: const Duration(
        seconds: 3), // Adjust the duration according to your needs
  );
}
