import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      this.onPress,
      required this.text,
      this.width,
      this.height,
      this.defaultColor,
      this.pressedColor,
      this.textColor,
      this.icon,
      required this.outlined});
  final VoidCallback? onPress;
  final String text;
  final double? width;
  final double? height;
  final Color? pressedColor;
  final Color? defaultColor;
  final Color? textColor;
  final Widget? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        padding: const EdgeInsets.all(10.0),
        height: height,
        width: width,
        // width: MediaQuery.of(context).size.width * 0.86,
        child: outlined
            ? OutlinedButton(
                onPressed: onPress,
                // style: ButtonStyle(),
                child: Center(
                    child: Text(
                  text.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                )))
            : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return pressedColor;
                    }
                    return defaultColor;
                  }),
                ),
                onPressed: onPress,
                child: Row(
                  mainAxisAlignment: icon == null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    icon ?? Container(),
                    Center(
                        child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ],
                ),
              ));
  }
}
