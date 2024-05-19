import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AvisContainer extends StatefulWidget {
  final String idDoc;
  const AvisContainer({super.key, required this.idDoc});

  @override
  State<AvisContainer> createState() => _AvisContainerState();
}

class _AvisContainerState extends State<AvisContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('évaluation')
          .where('id de docteur', isEqualTo: widget.idDoc)
          .orderBy('Date d envoi', descending: true)
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
                  child: Text('Pas de commentaire à afficher',
                      style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 20,
                          fontWeight: FontWeight.w500))),
            ]);
          } else {
            return Column(
              children: [
                Container(
                  height: 250,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var document = snapshot.data!.docs[index];
                      var idDocment = snapshot.data!.docs.first.id;
                      var idpat = document.get('id patient');
                      var evaluation = document.get('evaluation');
                      var commentaire = document.get('commentaire');
                      var horraire = document.get('Date d envoi');
                      //var heure = document.get('heure');
                      DateTime date = horraire.toDate();
                      int jour = date.day; // Jour du mois (1-31)
                      int mois = date.month; // Mois (1-12)
                      int annee = date.year; // Année
                      //   DateTime now = DateTime.parse(date);
                      DateTime now = DateTime.now();
                      DateTime nowdate = horraire.toDate();

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: idpat)
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.white,

                                          borderRadius: BorderRadius.circular(
                                              15), // Move the color property to decoration
                                          border: Border.all(
                                            color: Colors
                                                .blue, // Set the color of the border
                                            width:
                                                0.2, // Set the width of the border
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundImage:
                                                      NetworkImage(image),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  nom + " " + prenom,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(width: 10),
                                                RatingBar.builder(
                                                    itemSize: 20,
                                                    initialRating: evaluation,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    }),
                                                Text(
                                                  "  $jour" +
                                                      "/" +
                                                      "$mois" +
                                                      "/" +
                                                      "$annee",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blueGrey[700],
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(commentaire),
                                          ]),
                                        ),
                                      ),
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
