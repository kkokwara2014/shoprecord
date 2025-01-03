import 'package:flutter/material.dart';

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(17),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is required";
        } else {
          return null;
        }
      },
      keyboardType: textInputType,
    );
  }
}
