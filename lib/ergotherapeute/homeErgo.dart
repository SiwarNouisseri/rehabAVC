import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/ergotherapeute/drawerErgo.dart';
import 'package:first/orthophoniste/drawerOrth.dart';
import 'package:first/orthophoniste/AjouterEx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeErgo extends StatefulWidget {
  const HomeErgo({super.key});

  @override
  State<HomeErgo> createState() => _HomeErgoState();
}

class _HomeErgoState extends State<HomeErgo> {
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
        drawer: MyDrawerErgo(),
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
                return ListView(padding: EdgeInsets.zero, children: [
                  Container(
                      height: 220,
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
                                      "Bienvenue ",
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
                                            fontSize: 25),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 30),
                                child: FutureBuilder<String?>(
                                  future: imageUrlFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError ||
                                        snapshot.data == "none") {
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
                                        child: CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage:
                                              NetworkImage(snapshot.data!),
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
                    height: 40,
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
                  SizedBox(height: 20),
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
                  /* SizedBox(
            height: 40,
          ),*/

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, left: 30, bottom: 40, right: 30),
                    child: Text(
                      "Liste de mes patients :",
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
                  Container(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Column(children: [
                          CircleAvatar(
                            radius: 55.0,
                            backgroundImage: AssetImage("images/patient7.jpg"),
                          ),
                          Text("name"),
                          Text("surname")
                        ]),
                        SizedBox(
                          width: 30,
                        ),
                        Column(children: [
                          CircleAvatar(
                            radius: 55.0,
                            backgroundImage: AssetImage("images/patient6.jpg"),
                          ),
                          Text("name"),
                          Text("surname")
                        ]),
                        SizedBox(
                          width: 30,
                        ),
                        Column(children: [
                          CircleAvatar(
                            radius: 55.0,
                            backgroundImage: AssetImage("images/patient5.jpg"),
                          ),
                          Text("name"),
                          Text("surname")
                        ]),
                        SizedBox(
                          width: 30,
                        ),
                        Column(children: [
                          CircleAvatar(
                            radius: 55.0,
                            backgroundImage: AssetImage("images/patient4.jpg"),
                          ),
                          Text("name"),
                          Text("surname")
                        ]),
                      ],
                    ),
                  ),
                ]);
              }
            }
          },
        ));
  }
}
