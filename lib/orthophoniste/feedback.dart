import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/avisContainer.dart';
import 'package:first/orthophoniste/drawerOrth.dart';
import 'package:flutter/material.dart';

class AvisDoc extends StatefulWidget {
  const AvisDoc({super.key});

  @override
  State<AvisDoc> createState() => _AvisDocState();
}

class _AvisDocState extends State<AvisDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Avis Patients",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue[400],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleSpacing: 70.0,
        ),
        drawer: MyDrawerOrtho(),
        body: ListView(children: [
          Container(
            height: 40,
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
          SizedBox(height: 40),
          Container(
              height: 120,
              width: 150,
              child: Image.asset("images/chat (2).png")),
          SizedBox(height: 30),
          Container(
              height: 500,
              width: 150,
              child:
                  AvisContainer(idDoc: FirebaseAuth.instance.currentUser!.uid))
        ]));
  }
}
