import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/patient/progression.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotifEx extends StatefulWidget {
  const NotifEx({super.key});

  @override
  State<NotifEx> createState() => _NotifExState();
}

class _NotifExState extends State<NotifEx> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('progression')
          .where('id de patient',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: "pas encore")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return Column(children: [
              SizedBox(
                height: 100,
              ),
              Center(
                  child: Text('Pas de notifications à afficher',
                      style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 20,
                          fontWeight: FontWeight.w500))),
              SizedBox(
                height: 100,
              ),
              Image.asset(
                "images/interface-design.png",
                width: 150,
              )
            ]);
          } else {
            return Column(
              children: [
                Container(
                  height: 400,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var document = snapshot.data!.docs[index];
                      var idDoc = document.get('id de docteur');

                      var temps = document.get("date d'envoi");

                      var tempslim = document.get("date limite");
                      DateTime datee = tempslim.toDate();
                      int jourL = datee.day; // Jour du mois (1-31)
                      int moisL = datee.month; // Mois (1-12)
                      int anneeL = datee.year;
                      DateTime date = temps.toDate();
                      int jour = date.day; // Jour du mois (1-31)
                      int mois = date.month; // Mois (1-12)
                      int annee = date.year; // Année
                      int heure = date.hour; // Heure (0-23)
                      int minute = date.minute; // Minute (0-59)
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: idDoc)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:
                                    CircularProgressIndicator()); // Show loading indicator while fetching data
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Text(
                                  'Document does not exist on the database');
                            } else {
                              var prenom =
                                  snapshot.data!.docs.first.get('prenom');
                              var nom = snapshot.data!.docs.first.get('nom');

                              var image =
                                  snapshot.data!.docs.first.get('image url');
                              return GestureDetector(
                                onTap: () {
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Progression()),
                                  );*/
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 110,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.blue[50],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 400,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Container(
                                                      width: 50,
                                                      child: CircleAvatar(
                                                        radius: 25.0,
                                                        backgroundImage:
                                                            NetworkImage(image),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    prenom +
                                                        " " +
                                                        nom +
                                                        "\n Vous avez envoyé un exercice ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blueGrey[700],
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  SizedBox(width: 10),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 100),
                                                  child: Text(
                                                    "Envoyé le " +
                                                        "$jour" +
                                                        "/" +
                                                        "$mois" +
                                                        "/" +
                                                        "$annee" +
                                                        " " +
                                                        "à" +
                                                        " "
                                                            "$heure" +
                                                        ":" +
                                                        "$minute",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.blue[300],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 150.0),
                                                  child: Text(
                                                    "Date limite :" +
                                                        "$jourL" +
                                                        "/" +
                                                        "$moisL" +
                                                        "/" +
                                                        "$anneeL",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.red[200],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}
