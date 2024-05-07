import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/Exercicesend.dart';
import 'package:flutter/material.dart';

class PratiquerEXercice extends StatefulWidget {
  final String idDoc;
  final String idExercice;
  final String nom;
  const PratiquerEXercice(
      {super.key,
      required this.idExercice,
      required this.nom,
      required this.idDoc});

  @override
  State<PratiquerEXercice> createState() => _PratiquerEXerciceState();
}

class _PratiquerEXerciceState extends State<PratiquerEXercice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          iconTheme: IconThemeData(color: Colors.white),
          titleSpacing: 60,
          title: Text(
            widget.nom,
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
          ),
        ),
        body: ListView(children: [
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
            height: 700,
            width: 100,
            child: ExerciceSend(
              idExercice: widget.idExercice,
              documentId: widget.idDoc,
            ),
          )
        ]));
  }
}
