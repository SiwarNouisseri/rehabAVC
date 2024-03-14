import 'package:flutter/material.dart';

class ExercicesCog extends StatefulWidget {
  const ExercicesCog({super.key});

  @override
  State<ExercicesCog> createState() => _ExercicesCogState();
}

class _ExercicesCogState extends State<ExercicesCog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[400],
          title: Text(
            ' Exercices Cognitifs',
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
