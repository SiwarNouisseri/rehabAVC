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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:
                BorderSide(color: Colors.blue[500] ?? Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:
                BorderSide(color: Colors.blue[700] ?? Colors.blue, width: 1),
          ),
          labelText: hinttext,
          labelStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(
            icon.icon,
            color: Colors.blue[700],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
    );
  }
}
