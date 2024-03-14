import 'package:flutter/material.dart';

class ExercicesParole extends StatefulWidget {
  const ExercicesParole({super.key});

  @override
  State<ExercicesParole> createState() => _ExercicesParoleState();
}

class _ExercicesParoleState extends State<ExercicesParole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[400],
          title: Text(
            ' Exercices de parole',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          titleSpacing: 10,
        ),
        body: ListView(children: []));
  }
}
