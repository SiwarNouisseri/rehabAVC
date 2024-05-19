import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotifyMe extends StatefulWidget {
  const NotifyMe({super.key});

  @override
  State<NotifyMe> createState() => _NotifyMeState();
}

class _NotifyMeState extends State<NotifyMe> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('suivi')
          .where('id de patient',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: "acceptée")
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

                      var temps = document.get('acceptée le');

                      DateTime date = temps.toDate();
                      int jour = date.day;
                      int mois = date.month;
                      int annee = date.year;
                      int heure = date.hour;
                      int minute = date.minute;
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
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
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
                                                      "\n Vous avez accepté votre demande de suivi ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blueGrey[700],
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Spacer(),
                                                SizedBox(width: 10),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 100),
                                            child: Text(
                                              "Acceptée le " +
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
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue[300],
                                                fontSize: 12,
                                              ),
                                            ),
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
