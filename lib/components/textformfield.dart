import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final Icon icon;
  const CustomTextForm(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      required this.icon,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hinttext,
          icon: icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
    );
  }
}
