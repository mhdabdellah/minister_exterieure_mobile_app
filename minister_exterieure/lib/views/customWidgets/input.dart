import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input(
      {Key? key,
      required this.controller,
      // required this.label,
      required this.hintText,
      this.margin,
      this.prefix,
      this.suffix,
      this.obscureText,
      this.keyboardType,
      this.label,
      this.validator,
      this.maxLength})
      : super(key: key);

  final TextEditingController controller;
  // final String label;
  final String hintText;
  final IconData? prefix;
  final Widget? suffix;
  final bool? obscureText;
  final EdgeInsetsGeometry? margin;
  final TextInputType? keyboardType;
  final String? label;
  final String? Function(String?)? validator;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin!,
      child: TextFormField(
        maxLength: maxLength,
        validator: validator,
        controller: controller,
        obscureText: obscureText == null ? false : obscureText!,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            focusColor: Colors.blue[200],
            label: Text(label ?? ''),
            border: const OutlineInputBorder(),
            hintText: hintText,
            // icon: Icon(icon),
            suffix: suffix,
            prefixIcon: Icon(prefix)),
      ),
    );
  }
}
