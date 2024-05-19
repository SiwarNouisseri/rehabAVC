import 'package:first/orthophoniste/Rendez-vousAjouteDoc.dart';
import 'package:first/orthophoniste/calendrier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter/cupertino.dart';

class CalendrierFirst extends StatefulWidget {
  const CalendrierFirst({super.key});

  @override
  State<CalendrierFirst> createState() => _CalendrierFirstState();
}

class _CalendrierFirstState extends State<CalendrierFirst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
        title: Text(
          'Calendrier',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        titleSpacing: 90,
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
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Mes rendez-vous fixés",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 700,
            width: 700,
            child: RendAjoute(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalendrierOrtho()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
