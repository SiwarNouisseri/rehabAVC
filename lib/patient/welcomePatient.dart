// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/patient/doctor.dart';
import 'package:first/patient/drawer.dart';
import 'package:first/patient/ExercicesCog.dart';
import 'package:first/patient/ExercicesParole.dart';
import 'package:first/patient/ExercicesPhy.dart';
import 'package:first/patient/progression.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class WelcomePatient extends StatefulWidget {
  const WelcomePatient({super.key});

  @override
  State<WelcomePatient> createState() => _WelcomePatientState();
}

class _WelcomePatientState extends State<WelcomePatient> {
  String userName = "";
  @override
  late Future<String?> imageUrlFuture;
  @override
  void initState() {
    super.initState();
    imageUrlFuture = getimageUrl();
  }

  Future<String?> getimageUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('id', isEqualTo: user?.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
      return userData['image url'] as String?;
    } else {
      print("=================image not found ");
      return null;
    }
  }

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        drawer: MyDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while fetching data
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data!.docs.isEmpty) {
                return Text('Document does not exist on the database');
              } else {
                var prenom = snapshot.data!.docs.first.get('prenom');
                var nom = snapshot.data!.docs.first.get('nom');
                var id = snapshot.data!.docs.first.get('id');
                var image = snapshot.data!.docs.first.get('image url');
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[400] ?? Colors.blue,
                              Colors.blue[200] ?? Colors.blue,
                            ], // Couleurs du dégradé
                            begin: Alignment
                                .topLeft, // Position de départ du dégradé
                            end: Alignment
                                .bottomLeft, // Position d'arrêt du dégradé
                          ),
                          color: Colors.blue[300],
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue
                                  .withOpacity(0.3), // Couleur de l'ombre
                              spreadRadius: 3, // Rayon de diffusion de l'ombre
                              blurRadius: 8, // Rayon de flou de l'ombre
                              offset: Offset(0, 3), // Décalage de l'ombre
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 30.0),
                            child: ListView(children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 300.0),
                                child: GestureDetector(
                                  onTap: () {
                                    scaffoldkey.currentState!.openDrawer();
                                  },
                                  child: Icon(
                                    CupertinoIcons.list_dash,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              Row(children: [
                                SizedBox(
                                  width: 13,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Bienvenue    ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            fontSize: 32),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 1.0),
                                        child: Text(
                                          nom + " " + prenom,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[700],
                                              fontSize: 25),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: FutureBuilder<String?>(
                                    future: imageUrlFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError ||
                                          snapshot.data == null) {
                                        return CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage:
                                              AssetImage("images/avatar.jpeg"),
                                        );
                                      } else {
                                        return CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage:
                                              NetworkImage(snapshot.data!),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ]),
                            ]),
                          ),
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Progression()),
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
                              SizedBox(width: 10),
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
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.blue),
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
                                MaterialPageRoute(
                                    builder: (context) => ExercicePhy()),
                              );
                            },
                            child: Container(
                              width: 110,
                              child: Card(
                                color: Colors.green[300],
                                //color: Color.fromARGB(188, 170, 250, 192),
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
                                MaterialPageRoute(
                                    builder: (context) => ExercicesCog()),
                              );
                            },
                            child: Container(
                              width: 110,
                              child: Card(
                                color: Colors.amber[200],
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
                                color: Colors.red[300],
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
                      padding: const EdgeInsets.only(
                          left: 100.0, right: 100.0, top: 20),
                      child: Container(
                        height: 1, // Hauteur du trait de séparation
                        color: Colors.grey, // Couleur du trait de séparation
                        margin: EdgeInsets.symmetric(
                            vertical: 10), // Marge autour du trait
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
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Container(
                        width: 100,
                        height: 200,
                        child: DoctorScroll(
                          idPatient: id,
                          prenomPatient: prenom,
                          nomPatient: nom,
                          urlPatient: image,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ));
  }
}
