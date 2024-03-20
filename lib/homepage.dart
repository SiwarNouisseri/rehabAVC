// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/doctorDetail.dart';
import 'package:first/patient/drawer.dart';
import 'package:first/patient/ExercicesCog.dart';
import 'package:first/patient/ExercicesParole.dart';
import 'package:first/patient/ExercicesPhy.dart';
import 'package:first/patient/docteurSophie.dart';
import 'package:first/patient/docteurWalid.dart';
import 'package:first/patient/docteurhejer.dart';
import 'package:first/patient/docteurmehdi.dart';
import 'package:first/patient/progression.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userName = "";
  @override
  void initState() {
    super.initState();
    _getUserName(); // Call getUserName function in initState
  }

  Future<void> _getUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          setState(() {
            userName = data['name'] ?? ''; // Handle potential missing field
          });
        }
      }
    } catch (error) {
      print('=====================Error fetching username: $error');
      // Handle errors appropriately, e.g., display an error message to the user
    }
  }

  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? "";

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Colors.blue[300] ?? Colors.blue,
        animationCurve: Curves.linear,
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue[200] ?? Colors.blue,
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          Icon(
            Icons.message,
            color: Colors.white,
          ),
        ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
        title: Text(
          'Acceuil  ',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        titleSpacing: 10,
        actions: const [
          // Insérez ici votre image d'utilisateur
          Padding(
            padding: EdgeInsets.only(right: 20, top: 5),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage("images/avatar.jpeg"),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
              height: 120,
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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                  child: Row(children: [
                    Text(
                      "Bienvenue $userName",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                          fontSize: 30),
                    ),
                    SizedBox(width: 30),
                    /*CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage("images/avatar.jpeg"),
                    ),*/
                  ]),
                ),
              )),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Progression()),
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
                      "Consulter ma progression",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(width: 21),
                    Image.asset(
                      "images/progression.png",
                      width: 60,
                      height: 70,
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Catégories d'exercices : ",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontSize: 21),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExercicePhy()),
                    );
                  },
                  child: Container(
                    width: 110,
                    child: Card(
                      color: Color.fromARGB(188, 170, 250, 192),
                      shadowColor: Colors.blue,
                      child: Column(
                        children: [
                          Image.asset(
                            "images/exercice.png",
                            width: 60,
                            height: 70,
                          ),
                          Text(
                            " Physique ",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.blueGrey[700],
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExercicesCog()),
                    );
                  },
                  child: Container(
                    width: 110,
                    child: Card(
                      color: Colors.amber[100],
                      shadowColor: Colors.blue[600],
                      child: Column(
                        children: [
                          Image.asset(
                            "images/intelligence.png",
                            width: 60,
                            height: 70,
                          ),
                          Text(
                            "Cognitive",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.blueGrey[700],
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercicesParole()),
                    );
                  },
                  child: Container(
                    width: 110,
                    child: Card(
                      color: Colors.red[200],
                      shadowColor: Colors.blue,
                      child: Column(
                        children: [
                          Image.asset(
                            "images/personne.png",
                            width: 60,
                            height: 70,
                          ),
                          Text(
                            "Parole",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.blueGrey[700],
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 100.0, right: 100.0, top: 20),
            child: Container(
              height: 1, // Hauteur du trait de séparation
              color: Colors.grey, // Couleur du trait de séparation
              margin:
                  EdgeInsets.symmetric(vertical: 10), // Marge autour du trait
            ),
          ),
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              "Contactez les spécialistes : ",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontSize: 21),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Docteur1()),
                      );
                    },
                    child: DetailDoctor(
                        nom: "Dr.Oumaima Karray",
                        specialiste: "Orthophoniste",
                        image: "images/docteur.jpg"),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorMehdi()),
                    );
                  },
                  child: DetailDoctor(
                      nom: "Dr.  Mehdi Ben Salah",
                      specialiste: "Ergothérapeute",
                      image: "images/docteur1.jpg"),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DocteurWalid()),
                    );
                  },
                  child: DetailDoctor(
                    nom: "Dr. Walid Houaijia",
                    specialiste: "Orthophoniste",
                    image: "images/docteur2.jpg",
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorHejer()),
                    );
                  },
                  child: DetailDoctor(
                    nom: "Dr.  Hajer Triki",
                    specialiste: "Ergothérapeute",
                    image: "images/docteur4.jpg",
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
