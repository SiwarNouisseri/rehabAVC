import 'package:animated_icon/animated_icon.dart';
import 'package:first/orthophoniste/consulterpeogPat.dart';
import 'package:first/patient/ConsulterProg.dart';
import 'package:first/patient/exerciceChange.dart';
import 'package:flutter/material.dart';

class ProgressionPA extends StatefulWidget {
  final String idpat;
  final String nom;
  const ProgressionPA({super.key, required this.idpat, required this.nom});

  @override
  State<ProgressionPA> createState() => _ProgressionPAState();
}

class _ProgressionPAState extends State<ProgressionPA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
        title: Text(
          '   Progression',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        titleSpacing: 50,
      ),
      body: ListView(
        children: [
          Container(
            height: 60,
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
          SizedBox(height: 30),
          Container(
              height: 680,
              width: 400,
              child: ConsulterProgPa(
                idPat: widget.idpat,
                nom: widget.nom,
              ))
        ],
      ),
    );
  }
}
