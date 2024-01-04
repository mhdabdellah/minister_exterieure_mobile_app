// void result(String message) {
//     Get.dialog(
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(message),
//             const SizedBox(
//               width: 200,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(28.0),
//               child: TextButton(
//                   onPressed: () {
//                     // _dismissDialog();
//                     print("ok");
//                     // Navigator.pop(context);
//                     Get.back();
//                   },
//                   child: Text("d'accord")),
//             ),
//           ],
//         ),
//         barrierColor: Colors.black.withOpacity(0.8),
//         useSafeArea: true);
//   }

//   Future dialog(String message) {
//     return showDialog(
//       context: Get.context!,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(message),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(Get.context!).pop();
//               },
//               child: Text("Ok"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   alert(String message, var data) {
//     Get.defaultDialog(
//         title: message,
//         middleText: data.toString(),
//         backgroundColor: Colors.teal,
//         titleStyle: TextStyle(color: Colors.white),
//         middleTextStyle: TextStyle(color: Colors.white),
//         radius: 30);
//   }