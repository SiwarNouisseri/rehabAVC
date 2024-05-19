import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/calendrier.dart';
import 'package:first/orthophoniste/calendrierFirestPage.dart';
import 'package:first/orthophoniste/drawerOrth.dart';
import 'package:first/orthophoniste/AjouterEx.dart';
import 'package:first/orthophoniste/envoyerEx.dart';
import 'package:first/orthophoniste/map.dart';
import 'package:first/orthophoniste/mesPatients.dart';
import 'package:first/orthophoniste/profileOrtho.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
      drawer: MyDrawerOrtho(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return ListView(padding: EdgeInsets.zero, children: [
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[400] ?? Colors.blue,
                          Colors.blue[200] ?? Colors.blue,
                        ], // Couleurs du dégradé
                        begin:
                            Alignment.topLeft, // Position de départ du dégradé
                        end:
                            Alignment.bottomLeft, // Position d'arrêt du dégradé
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
                        padding: const EdgeInsets.only(left: 10.0, right: 30.0),
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
                                    padding: const EdgeInsets.only(left: 1.0),
                                    child: Text(
                                      "Dr." + " " + nom + " " + prenom,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                          fontSize: 22),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: FutureBuilder<String?>(
                                future: imageUrlFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError ||
                                      snapshot.data == null) {
                                    return Container(
                                      width: 75,
                                      child: CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage:
                                            AssetImage("images/avatar.jpeg"),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      width: 75,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileOrtho()),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage:
                                              NetworkImage(snapshot.data!),
                                        ),
                                      ),
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
                  height: 60,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AjouterEx()),
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
                            "Ajouter des exercices",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[700],
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 90),
                          Image.asset(
                            "images/addd.png",
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EnvoyerOrtho()),
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
                            "Envoyer des exercices",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[700],
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 90),
                          Image.asset(
                            "images/red.png",
                            width: 55,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                  child: Container(
                    color: Colors.blueGrey[300],
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                  child: Text(
                    "Fixer ma calendrier :",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        fontFamily: " PlaypenSans",
                        color: Colors.indigo),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 0),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendrierFirst()),
                            );
                          },
                          child: Container(
                              height: 100,
                              width: 50,
                              child: Image.asset(
                                  "images/medical-appointment.png")),
                        ),
                      ),
                      GestureDetector(child: Icon(Icons.map_outlined))
                    ],
                  ),
                ),
              ]);
            }
          }
        },
      ),
    );
  }
}
