import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoadingIndicator() {
  Get.dialog(
    const Center(
      child: CircularProgressIndicator(), // Default circular progress indicator
    ),
    barrierDismissible: true, // User cannot dismiss it by tapping outside
  );
}

void dismissLoadingIndicator() {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}
