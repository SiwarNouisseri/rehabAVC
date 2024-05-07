import 'package:flutter/material.dart';

class textFormRead extends StatelessWidget {
  final String hinttext;
  final String text;
  const textFormRead({
    super.key,
    required this.hinttext,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: text,
      readOnly: true,
      decoration: InputDecoration(
        labelStyle:
            TextStyle(color: Colors.orange[300], fontWeight: FontWeight.bold),

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
        //labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
