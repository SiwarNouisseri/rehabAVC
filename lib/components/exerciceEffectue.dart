import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/noteDocteur.dart';
import 'package:first/components/pratiquerEx.dart';
import 'package:flutter/material.dart';

class ExerciceEffectuer extends StatefulWidget {
  final String type;
  const ExerciceEffectuer({Key? key, required this.type});

  @override
  State<ExerciceEffectuer> createState() => _ExerciceEffectuerState();
}

class _ExerciceEffectuerState extends State<ExerciceEffectuer> {
  DateTime dateStatic = DateTime.utc(0000);

  static bool documentsFound = true;
  static String notee = "cliquer pour consulter la note et la date limite";

  void updateNote() {
    setState(() {});
  }
  // Par défaut, un contenu initial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              ' Des défis quotidiens pour une rééducation optimale ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.indigo,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 90,
            width: 90,
            child: Image.asset(
              "images/victory.png",
              width: 40,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('progression')
                  .where('id de patient',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> progressionSnapshot) {
                if (progressionSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (progressionSnapshot.hasError) {
                    return Text('Error: ${progressionSnapshot.error}');
                  } else if (progressionSnapshot.data!.docs.isEmpty) {
                    documentsFound = false;
                    print("++++++++++++$documentsFound");

                    return Text(
                      "Veuillez attendre un peu jusqu'à votre docteur envoie des exercices",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.green[300],
                        fontSize: 15,
                      ),
                    );
                  } else {
                    documentsFound = true;
                    print("++++++++++++$documentsFound");
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: progressionSnapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int i) {
                          var progressionDocument =
                              progressionSnapshot.data!.docs[i];
                          var idExercice = progressionDocument['id exercice'];
                          var status = progressionDocument['status'];
                          var documentid = progressionDocument.id;

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('exercices')
                                .where(FieldPath.documentId,
                                    isEqualTo: idExercice)
                                .where('type', isEqualTo: widget.type)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> exerciseSnapshot) {
                              if (exerciseSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (exerciseSnapshot.hasError) {
                                  return Text(
                                      'Error: ${exerciseSnapshot.error}');
                                } else if (exerciseSnapshot
                                    .data!.docs.isEmpty) {
                                  return Container();
                                } else {
                                  var filteredExercises = exerciseSnapshot
                                      .data!.docs
                                      .where((exercice) {
                                    return exercice.id == idExercice &&
                                        status == 'pas encore';
                                  }).toList();

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: filteredExercises.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var exercice = filteredExercises[index];
                                      var idEx = exercice.id;
                                      var type = exercice['type'];
                                      var name = exercice['nom'];
                                      var description = exercice['description'];
                                      var url = exercice.get('urlvideo');

                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Card(
                                                elevation: 2,
                                                color: Colors.blue[50],
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Exercice",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .green[300],
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          Text(
                                                            " ${i + 1} : " +
                                                                " ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .green[300],
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          Text(
                                                            name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 20),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 210),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PratiquerEXercice(
                                                                            idExercice:
                                                                                idEx,
                                                                            nom:
                                                                                name,
                                                                            idDoc:
                                                                                documentid,
                                                                          )),
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      "Commencer",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .indigo,
                                                                      )),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Icon(
                                                                      Icons
                                                                          .arrow_circle_right,
                                                                      size: 15,
                                                                      color: Colors
                                                                          .indigo),
                                                                ]),
                                                          ),
                                                        ),
                                                      )
                                                    ]))),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Note(
              notee: notee,
              dateStatic: dateStatic,
            ),
          )
        ],
      ),
    );
  }
}
