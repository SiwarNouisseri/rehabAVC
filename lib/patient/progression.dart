import 'package:flutter/material.dart';

class Progression extends StatefulWidget {
  const Progression({super.key});

  @override
  State<Progression> createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[400],
          title: Text(
            ' Ma progression',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          titleSpacing: 10,
        ),
        body: ListView(
          children: [],
        ));
  }
}
