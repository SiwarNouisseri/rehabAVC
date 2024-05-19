import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RendezContainer extends StatefulWidget {
  const RendezContainer({super.key});

  @override
  State<RendezContainer> createState() => _RendezContainerState();
}

class _RendezContainerState extends State<RendezContainer> {
  bool dateNow = false;
  @override
  void updateDocumentField(String docId) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rendez-vous').doc(docId);

    // Update the specific field using the update method
    documentReference.update({
      'status': 'annulé',
      'id patient': FirebaseAuth.instance.currentUser!.uid
    }).then((value) {
      print('updated document successd');
    }).catchError((error) {
      print('Failed to update document field: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rendez-vous')
          .where('id patient',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: "reservé")
          .orderBy('date', descending: false)
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
                  child: Text('Pas de rendez-vous à afficher',
                      style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 20,
                          fontWeight: FontWeight.w500))),
              SizedBox(
                height: 100,
              ),
              Image.asset(
                "images/appointment.png",
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
                      var idDocment = snapshot.data!.docs.first.id;
                      var idDoc = document.get('id de docteur');

                      var horraire = document.get('date');
                      var heure = document.get('heure');
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
                                      height: 111,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Card(
                                        color: Colors.lightBlue[50],
                                        child: Column(
                                          children: [
                                            SizedBox(height: 5),
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
                                                  Container(
                                                    height: 70,
                                                    width: 200,
                                                    child: ListView(
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          prenom + " " + nom,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .blue[700],
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Le :" +
                                                              "$jour" +
                                                              "/" +
                                                              "$mois" +
                                                              "/" +
                                                              "$annee",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .blueGrey[700],
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          heure,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .blueGrey[700],
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (date.year == now.year &&
                                                      date.month == now.month &&
                                                      date.day == now.day)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 40.0),
                                                      child: Container(
                                                        height: 20,
                                                        width: 100,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255, 40, 189, 45),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          2)),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8.0),
                                                          child: Text(
                                                            "Aujourd'hui",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            if (date.year != now.year &&
                                                date.month != now.month &&
                                                date.day != now.day)
                                              Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 320),
                                              child: GestureDetector(
                                                onTap: () {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.error,
                                                    animType:
                                                        AnimType.rightSlide,
                                                    title: 'Annulation',
                                                    desc:
                                                        "Vous êtes sûr d'annuler ce rendez-vous ?",
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () {
                                                      updateDocumentField(
                                                          idDocment);
                                                    },
                                                  ).show();
                                                },
                                                child: Image.asset(
                                                  "images/bin.png",
                                                  width: 25,
                                                ),
                                              ),
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
