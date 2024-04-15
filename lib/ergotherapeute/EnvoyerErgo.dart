import 'package:flutter/material.dart';

class EnvoyerEgo extends StatefulWidget {
  const EnvoyerEgo({super.key});

  @override
  State<EnvoyerEgo> createState() => _EnvoyerEgoState();
}

class _EnvoyerEgoState extends State<EnvoyerEgo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
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
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0),
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    "Envoyer des exercices",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 24),
                  ),
                ),
              ]),
            ),
          ),
        ),
        SizedBox(
          height: 120,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Text(
            "Rien à voir jusqu’à ce que vous téléchargiez des documents",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey,
                fontSize: 13),
          ),
        ),
        SizedBox(
          height: 80,
        ),
        Container(
            width: 20,
            height: 200,
            child: Image.asset("images/not-found.png", width: 40))
      ],
    ));
  }
}
