import 'package:flutter/material.dart';

class LogoHandler extends StatelessWidget {
  const LogoHandler({super.key, required this.margin});

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        // width: 100,
        // height: 100,
        child: Column(
          children: [
            const Image(
              // image: AssetImage('assets/dem.png'),
              image: AssetImage('assets/logo.png'),
              width: 90,
              height: 88,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  // "Don".tr,
                  "قنصليتي",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                // Text(
                //   // "App".tr,
                //   "d'Exterieur",
                //   style: TextStyle(
                //       fontSize: 28,
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold),
                // ),
              ],
            )
          ],
        ));
  }
}
