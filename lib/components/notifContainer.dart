import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Notif extends StatefulWidget {
  const Notif({
    super.key,
  });

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> fetchUserData(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(id).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<dynamic> userDataList = userData.values.toList();
      return userDataList;
    }

    return [];
  }

  Future<void> removeFollowUpRequest(String idPatient) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('suivi')
          .where('id de patient', isEqualTo: idPatient)
          .where('id de docteur',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one matching document, get its reference and delete it
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        await docSnapshot.reference.delete();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Succès',
          desc: 'Demande de suivi supprimée avec succès',
        ).show();
        print('Demande de suivi supprimée avec succès');
      } else {
        print('Aucune demande de suivi trouvée pour ce patient');
      }
    } catch (e) {
      print('Erreur lors de la suppression de la demande de suivi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('suivi')
          .where('id de docteur',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: "en cours de traitement")
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
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var document = snapshot.data!.docs[index];

                      var temps = document.get('envoyé le');
                      var idPatient = document.get('id de patient');
                      var idDoc = document.get('id de docteur');

                      DateTime date = temps.toDate();
                      int jour = date.day; // Jour du mois (1-31)
                      int mois = date.month; // Mois (1-12)
                      int annee = date.year; // Année
                      int heure = date.hour; // Heure (0-23)
                      int minute = date.minute; // Minute (0-59)
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: idPatient)
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

                              return Dismissible(
                                key: Key(document.id),
                                onDismissed: (direction) async {
                                  try {
                                    // Delete the current document

                                    FirebaseFirestore.instance
                                        .collection('suivi')
                                        .add({
                                      'id de docteur': idDoc,
                                      'status': "acceptée",
                                      'id de patient': idPatient,
                                      'envoyeé le': temps,
                                      'acceptée le':
                                          FieldValue.serverTimestamp(),
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('suivi')
                                        .doc(document.id)
                                        .delete();

                                    // Add a new document with updated information

                                    // Show a snackbar indicating success
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Demande acceptée',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));

                                    print("success");
                                    setState(() {
                                      snapshot.data!.docs.removeAt(index);
                                    });
                                  } catch (error) {
                                    print(
                                        'Error handling dismiss action: $error');
                                    // Handle the error here.
                                  }
                                },
                                background: Container(color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 7, right: 7),
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
                                                        "\n vous avez envoyé une demande de suivi",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blueGrey[700],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        removeFollowUpRequest(
                                                            idPatient),
                                                    child: Image.asset(
                                                      "images/bin.png",
                                                      width: 25,
                                                    ),
                                                  ),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 200.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 170,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 35, 197, 40),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4.0),
                                                          child: Text(
                                                            "Glisser pour valider la demande ",
                                                            style: TextStyle(
                                                                fontSize: 9,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Image.asset(
                                                            "images/swipe.png",
                                                            width: 15)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
