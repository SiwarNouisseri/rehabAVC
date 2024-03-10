import 'package:flutter/material.dart';

class Docteur1 extends StatelessWidget {
  const Docteur1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              "images/docteur.jpg",
              height: 250,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text("Dr. Sophia Martin",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey[700],
                  fontSize: 17,
                )),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              height: 25,
              width: 120,
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
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Orthophoniste",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20),
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 380,
                    decoration: BoxDecoration(
                      //color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(
                          15), // Move the color property to decoration
                      border: Border.all(
                        color: Colors.blue, // Set the color of the border
                        width: 1, // Set the width of the border
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                          "Dr. Sophia Martin,avec plus de 9 années d'expérience dans le diagnostic et le traitement des troubles de la parole et du langage avec son approche empathique et ses techniques avancées garantissent des soins personnalisés pour améliorer les compétences de communication chez les enfants et les adultes",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.blueGrey[700],
                            fontSize: 13,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
