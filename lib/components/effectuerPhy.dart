import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/noteDocteur.dart';
import 'package:first/components/pratiquerEx.dart';
import 'package:flutter/material.dart';

class EffectuerPhy extends StatefulWidget {
  final String type;
  const EffectuerPhy({Key? key, required this.type});

  @override
  State<EffectuerPhy> createState() => _EffectuerPhyState();
}

class _EffectuerPhyState extends State<EffectuerPhy> {
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
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.docs.isEmpty) {
                    documentsFound = false;
                    print("++++++++++++$documentsFound");

                    return Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 37.0, right: 37.0),
                          child: Text(
                              "Il n’y a pas d’exercices à montrer, Veuillez attendre que votre médecin vous envoie",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                        ),
                        SizedBox(height: 40),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 70.0, right: 70.0),
                          child: Image.asset(
                            'images/welcome.png',
                          ),
                        )
                      ],
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
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int i) {
                          var document = snapshot.data!.docs[i];
                          var documentid = document.id;
                          var dateLimite = document['date limite'];
                          var idExercice = document['id exercice'];
                          var status = document['status'];
                          var note = document['note'];
                          var dateEnv = document["date d'envoi"];
                          DateTime date = dateLimite.toDate();

                          if (i == 0) {
                            notee = note;

                            dateStatic = date;
                          }

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('exercices')
                                .where(FieldPath.documentId,
                                    isEqualTo: idExercice)
                                .where('type', isEqualTo: widget.type)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 37.0, right: 37.0),
                                        child: Text(
                                            "Il n’y a pas d’exercices à montrer, Veuillez attendre que votre médecin vous envoie",
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15)),
                                      ),
                                      SizedBox(height: 40),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 70.0, right: 70.0),
                                        child: Image.asset(
                                          'images/welcome.png',
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  print("++++++++++++$documentsFound");
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var document = snapshot.data!.docs[index];
                                      var idEx = document.id;
                                      var type = document['type'];
                                      var name = document['nom'];
                                      var description = document['description'];

                                      var url = document.get('urlvideo');

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
