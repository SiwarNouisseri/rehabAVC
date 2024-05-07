import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:first/components/congratulation.dart';
import 'package:first/components/displayVideoDoc.dart';
import 'package:first/components/exerciceEffectue.dart';
import 'package:first/components/videoEx.dart';
import 'package:first/patient/ExercicesParole.dart';
import 'package:first/patient/signalerUnProbleme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciceSend extends StatefulWidget {
  final String idExercice;
  final String documentId;
  const ExerciceSend(
      {super.key, required this.idExercice, required this.documentId});

  @override
  State<ExerciceSend> createState() => _ExerciceSendState();
}

Future<void> updateField(String newvalue, String documentId) async {
  FirebaseFirestore.instance
      .collection('progression')
      .doc(documentId)
      .update({'status': newvalue})
      .then((value) => print('Champ mis à jour avec succès'))
      .catchError((error) => print('Erreur lors de la mise à jour : $error'));
}

class _ExerciceSendState extends State<ExerciceSend> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
            body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('exercices')
                    .where(FieldPath.documentId, isEqualTo: widget.idExercice)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      var description =
                          snapshot.data!.docs.first.get('description');
                      var url = snapshot.data!.docs.first.get('urlvideo');
                      var nom = snapshot.data!.docs.first.get('nom');
                      return ListView(
                        children: [
                          /* Padding(
                            padding: const EdgeInsets.only(
                                left: 85, right: 80, bottom: 3, top: 10),
                            child: Text(
                              "Pratiquer votre exercice",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent[700],
                              ),
                            ),
                          ),
                          Container(
                              height: 70,
                              width: 50,
                              child: Image.asset("images/brain-training.png")),
                          SizedBox(
                            height: 20,
                          ),*/
                          Container(
                              height: 300,
                              width: 400,
                              child: videoEx(url: url)),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.blueAccent[700] ??
                                      Colors.blueAccent,
                                  width: 1.0,
                                ),
                              ),
                              width: 100,
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 50,
                                            width: 40,
                                            child: Image.asset(
                                                "images/documents.png")),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Description : ",
                                          style: TextStyle(
                                              color: Colors.blueAccent[700],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      description,
                                      style: TextStyle(
                                          color: Colors.blueGrey[700],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                height: 50,
                                width: 230,
                                child: MaterialButton(
                                  height: 45,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white, width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular((90))),
                                  color: CupertinoColors.activeGreen,
                                  onPressed: () {
                                    Stack(
                                      children: [],
                                    );
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      title: 'Validation',
                                      desc:
                                          'Vous êtes sûr de valider cet exercice ?',
                                      btnCancelOnPress: () async {},
                                      btnCancelText: "Non",
                                      btnOkText: "Oui",
                                      btnOkOnPress: () async {
                                        await updateField(
                                            "validé", widget.documentId);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfettiAnimation()),
                                        );
                                      },
                                    ).show();

                                    print(
                                        "+++++++++++++++++++++${widget.documentId}");
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Valider un exercice ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                        Spacer(),
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Container(
                                height: 50,
                                width: 230,
                                child: MaterialButton(
                                  height: 45,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white, width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular((90))),
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Signaler(
                                                documentId: widget.documentId,
                                              )),
                                    );
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Signaler une probléme",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                        Spacer(),
                                        Container(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                "images/reject.png")),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }
                })),
      ],
    );
  }
}
