import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// void errorSnackBar({required String message}) {
//   Get.snackbar(
//     'Erreur !'.tr,
//     '',
//     snackPosition: SnackPosition.TOP,
//     backgroundColor: const Color.fromARGB(255, 244, 229, 224),
//     messageText: Row(
//       children: [
//         SizedBox(
//             height: 60,
//             width: 60,
//             child: Lottie.asset("assets/animated_icons/error.json")),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(message.tr,
//                 style: const TextStyle(
//                   color: Colors.red,
//                 )),
//           ],
//         ),
//       ],
//     ),
//     // colorText: Colors.green,
//     colorText: Colors.red,
//     boxShadows: [
//       BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           offset: const Offset(1, 1),
//           blurRadius: 10)
//     ],
//   );
// }
void errorSnackBar({required String message}) {
  Get.snackbar(
    // 'Erreur !'.tr,
    '',
    '',
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color.fromARGB(255, 244, 229, 224),
    messageText: Row(
      mainAxisSize: MainAxisSize.min, // Ajouté pour limiter la largeur de Row
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Lottie.asset("assets/animated_icons/error.json"),
        ),
        Expanded(
          // Utilisez Expanded pour que la colonne occupe l'espace restant
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.tr,
                style: const TextStyle(
                  color: Colors.red,
                ),
                maxLines: 3, // Nombre maximum de lignes pour le texte
                overflow: TextOverflow
                    .ellipsis, // Ajoute des points de suspension si le texte est trop long
              ),
            ],
          ),
        ),
      ],
    ),
    colorText: Colors.red,
    // boxShadows: [
    //   BoxShadow(
    //     color: Colors.black.withOpacity(0.1),
    //     offset: const Offset(1, 1),
    //     blurRadius: 10,
    //   ),
    // ],
    isDismissible:
        true, // Permet à l'utilisateur de balayer pour fermer le SnackBar
    duration: const Duration(seconds: 5), // Durée d'affichage du SnackBar
  );
}
