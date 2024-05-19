import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/messOrtho.dart';
import 'package:first/orthophoniste/messagerie/messagerieOrtho.dart';
import 'package:first/patient/messagerie/docteurDisscussion.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotifyMess extends StatefulWidget {
  const NotifyMess({super.key});

  @override
  State<NotifyMess> createState() => _NotifyMessState();
}

class _NotifyMessState extends State<NotifyMess> {
  Future<void> updateMessages(String conversationId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('message')
          .where('id conver ', isEqualTo: conversationId)
          .where("recepteur", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var document in querySnapshot.docs) {
        await document.reference.update({
          'statut': 'vu',
        });
      }

      print('Champs mis à jour avec succès.');
    } catch (e) {
      print('Erreur lors de la mise à jour des champs : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('message')
          .where('recepteur', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('statut', isEqualTo: "non vu")
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
                      var envoyeur = document.get('envoyeur');
                      var recepteur = document.get('recepteur');
                      var idConver = document.get('id conver ');
                      var idDocment = document.id;
                      var temps = document.get('Date');
                      var heure = document.get('heure');
                      List<String> heureMinuteSeconde = heure.split(":");
                      String heureExtraite = heureMinuteSeconde[0];
                      String minuteExtraite = heureMinuteSeconde[1];
                      DateTime date = temps.toDate();
                      int jour = date.day;
                      int mois = date.month;
                      int annee = date.year;

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: envoyeur)
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
                              var patient = nom + " " + prenom;
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Messagerie(
                                              patient: patient,
                                              image: image,
                                              idConver: idConver,
                                              idPatient: recepteur,
                                            ),
                                          ),
                                        );
                                        updateMessages(idConver);
                                      },
                                      child: Container(
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
                                                        "\n Vous avez envoyé un message ",
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
                                            Padding(
                                              padding: const EdgeInsets.only(
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
                                                    " " +
                                                    heureExtraite +
                                                    ":" +
                                                    minuteExtraite,
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
