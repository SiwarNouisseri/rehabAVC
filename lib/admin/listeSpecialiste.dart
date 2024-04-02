import 'package:first/admin/docteurWidget.dart';
import 'package:flutter/material.dart';

class Specialiste extends StatefulWidget {
  const Specialiste({super.key});

  @override
  State<Specialiste> createState() => _SpecialisteState();
}

class _SpecialisteState extends State<Specialiste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Container(
          height: 100,
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
          child: Row(children: [
            SizedBox(
              width: 80,
            ),
            Text(
              "Consulter liste des spécialistes ",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 19),
            ),
          ])),
      SizedBox(
        height: 40,
      ),
      Container(height: 2000, child: DoctorWidget())
    ]));
  }
}
