import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/admin/listePatient.dart';
import 'package:first/admin/listeSpecialiste.dart';
import 'package:first/admin/reclamations.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeAdmin extends StatefulWidget {
  const WelcomeAdmin({super.key});

  @override
  State<WelcomeAdmin> createState() => _WelcomeAdminState();
}

class _WelcomeAdminState extends State<WelcomeAdmin> {
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
          child: Row(
            children: [
              SizedBox(
                width: 80,
              ),
              Text(
                "Administrateur",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 25),
              ),
              SizedBox(
                width: 100,
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await googleSignIn.disconnect();
                  } catch (e) {
                    print(
                        "=============Erreur lors de la déconnexion de Google Sign-In: $e");
                  }

                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  } catch (e) {
                    print(
                        "=====================Erreur lors de la déconnexion de FirebaseAuth: $e");
                  }
                },
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 100),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Patient()),
            );
          },
          child: Container(
            width: 20,
            height: 100,
            margin: EdgeInsets.only(right: 15, left: 15),
            child: Card(
              shadowColor: Colors.blue,
              child: Row(
                children: [
                  SizedBox(width: 25),
                  Text(
                    "Les patients",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[700],
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 130),
                  Image.asset(
                    "images/crowd.png",
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Specialiste()),
            );
          },
          child: Container(
            width: 20,
            height: 100,
            margin: EdgeInsets.only(right: 15, left: 15),
            child: Card(
              shadowColor: Colors.blue,
              child: Row(
                children: [
                  SizedBox(width: 25),
                  Text(
                    "Les spécialistes",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[700],
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 90),
                  Image.asset(
                    "images/medical-team.png",
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 50),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Reclamation()),
            );
          },
          child: Container(
            width: 20,
            height: 100,
            margin: EdgeInsets.only(right: 15, left: 15),
            child: Card(
              shadowColor: Colors.blue,
              child: Row(
                children: [
                  SizedBox(width: 25),
                  Text(
                    "Les réclamations",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[700],
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 90),
                  Image.asset(
                    "images/bad-review.png",
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
