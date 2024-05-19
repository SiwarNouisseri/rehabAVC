import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VoirRendazPatient extends StatefulWidget {
  final String idDoc;
  const VoirRendazPatient({super.key, required this.idDoc});

  @override
  State<VoirRendazPatient> createState() => _VoirRendazPatientState();
}

class _VoirRendazPatientState extends State<VoirRendazPatient> {
  Future<bool> checkExistingFollowUpRequest() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rendez-vous')
        .where('id patient', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('id de docteur', isEqualTo: widget.idDoc)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void updateDocumentField(String docId) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rendez-vous').doc(docId);

    // Update the specific field using the update method
    documentReference.update({
      'status': 'reservé',
      'id patient': FirebaseAuth.instance.currentUser!.uid
    }).then((value) {
      print('updated document successd');
    }).catchError((error) {
      print('Failed to update document field: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rendez-vous')
          .orderBy('date', descending: false)
          .where('id de docteur', isEqualTo: widget.idDoc)
          .where('status', isEqualTo: 'Non pris')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          )); // Show loading indicator while fetching data
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return Column(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    child: Image.asset("images/calendar (1).png")),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Pas de rendez-vous disponible pour ce spécialiste pour le moment',
                    style: TextStyle(
                        color: Colors.red[400], fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          } else {
            return Column(children: [
              Container(
                  height: 80,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var document = snapshot.data!.docs[index];
                        var idDocement = document.id;
                        var idDoc = document.get('id de docteur');
                        var status = document.get('status');
                        var horraire = document.get('date');
                        var heure = document.get('heure');
                        DateTime date = horraire.toDate();
                        int jour = date.day; // Jour du mois (1-31)
                        int mois = date.month; // Mois (1-12)
                        int annee = date.year; // Année
                        //   DateTime now = DateTime.parse(date);
                        DateTime now = DateTime.now();
                        DateTime nowdate = horraire.toDate();

                        return Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Validation',
                                    btnOkOnPress: () async {
                                      bool hasExistingRequest =
                                          await checkExistingFollowUpRequest();
                                      print(
                                          "++++++++++$hasExistingRequest++++++++++++");
                                      print(
                                          "++++++++++++++++++${widget.idDoc}++++++++++");

                                      if (hasExistingRequest) {
                                        // Afficher un message ou désactiver le bouton d'envoi de demande
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Rappel',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                'Vous avez déjà un rendez-vous en cours',
                                                style: TextStyle(
                                                    color: Colors.blueGrey[700],
                                                    fontWeight:
                                                        FontWeight.w700),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        );

                                        print(
                                            'Le patient a déjà une demande de suivi en attente.');
                                        // Vous pouvez afficher un message d'erreur à l'utilisateur ici
                                      } else {
                                        updateDocumentField(idDocement);
                                      }
                                    },
                                    btnCancelOnPress: () {},
                                    desc:
                                        "Vous êtes sûr de prendre ce rendez-vous ?",
                                  ).show();
                                },
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                                Colors.blue[200] ?? Colors.blue,
                                            width: 2)),
                                    child: Container(
                                      height: 80,
                                      width: 200,
                                      child: ListView(children: [
                                        Row(
                                          children: [
                                            Container(
                                                height: 30,
                                                width: 30,
                                                child: Image.asset(
                                                    "images/deadline.png")),
                                            Container(
                                              width: 30,
                                            ),
                                            Text(
                                                "$jour" +
                                                    "/" +
                                                    "$mois" +
                                                    "/" +
                                                    "$annee",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: Colors.blueGrey)),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(heure,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.blue)),
                                        )
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      }))
            ]);
          }
        }
      },
    ));
  }
}
