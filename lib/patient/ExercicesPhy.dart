import 'package:first/components/effectuerPhy.dart';
import 'package:first/components/exerciceEffectue.dart';
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
          ' Exercices physique ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        titleSpacing: 30,
      ),
      body: ListView(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[400] ?? Colors.blue,
                  Colors.blue[200] ?? Colors.blue,
                ], // Couleurs du dégradé
                begin: Alignment.topLeft, // Position de départ du dégradé
                end: Alignment.bottomLeft, // Position d'arrêt du dégradé
              ),
              color: Colors.blue[300],
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3), // Couleur de l'ombre
                  spreadRadius: 3, // Rayon de diffusion de l'ombre
                  blurRadius: 8, // Rayon de flou de l'ombre
                  offset: Offset(0, 3), // Décalage de l'ombre
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Container(
              width: 50,
              height: 600,
              child: ExerciceEffectuer(
                type: 'Physique',
              ))
        ],
      ),
    );
  }
}
