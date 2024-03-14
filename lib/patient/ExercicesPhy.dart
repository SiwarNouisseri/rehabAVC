import 'package:flutter/material.dart';

class ExercicePhy extends StatefulWidget {
  const ExercicePhy({super.key});

  @override
  State<ExercicePhy> createState() => _ExercicePhyState();
}

class _ExercicePhyState extends State<ExercicePhy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
        title: Text(
          ' Exercices Physique ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        titleSpacing: 10,
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
