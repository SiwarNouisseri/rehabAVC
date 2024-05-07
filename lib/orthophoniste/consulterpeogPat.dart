import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/dossierMedPatient.dart';
import 'package:first/patient/consulterDossier.dart';
import 'package:first/patient/dossierMedical.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ConsulterProgPa extends StatefulWidget {
  final String idPat;
  final String nom;
  const ConsulterProgPa({Key? key, required this.idPat, required this.nom});

  @override
  State<ConsulterProgPa> createState() => _ConsulterProgPaState();
}

class _ConsulterProgPaState extends State<ConsulterProgPa> {
  Color getStatusColor(String status) {
    if (status == 'validé') {
      return Color.fromARGB(255, 120, 192, 38);
    } else if (status == 'pas encore') {
      return Color.fromARGB(255, 233, 215, 52) ?? Colors.yellow;
    } else {
      return Color.fromARGB(255, 241, 70, 58);
    }
  }

  Color getStatusBorderColor(String status) {
    if (status == 'validé') {
      return Color.fromARGB(255, 120, 192, 38);
    } else if (status == 'pas encore') {
      return Colors.yellow[200] ?? Colors.yellow;
    } else {
      return Color.fromARGB(255, 241, 70, 58);
    }
  }

  Color getStatusTextColor(String status) {
    if (status == 'validé') {
      return Colors.green[900] ?? Colors.green;
    } else if (status == 'pas encore') {
      return Colors.yellow[900] ?? Colors.yellow;
    } else {
      return Color.fromARGB(255, 120, 47, 47) ?? Colors.red;
    }
  }

  Icon getStatusIcon(String status) {
    if (status == 'validé') {
      return Icon(
        Icons.check,
        color: Colors.white,
      );
    } else if (status == 'pas encore') {
      return Icon(Icons.auto_graph_rounded, color: Colors.white);
    } else {
      return Icon(Icons.close_rounded, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          dossierPatient(
            idPat: widget.idPat,
            nom: widget.nom,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Compte rendu des activités :",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
                color: Colors.blue[400],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('progression')
                .where('id de patient', isEqualTo: widget.idPat)
                .where('id de docteur',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy("date d'envoi", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.docs.isEmpty) {
                  return Container();
                } else {
                  return Container(
                    height: 550,
                    // height: MediaQuery.of(context).size.height,
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
                        var probleme = document["problème"];
                        DateTime date = dateLimite.toDate();
                        DateTime dateTime = dateEnv.toDate();
                        print("+++++++++++++$documentid");
                        int day = dateTime.day;
                        int month = dateTime.month;
                        int year = dateTime.year;

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('exercices')
                              .where(FieldPath.documentId,
                                  isEqualTo: idExercice)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.data!.docs.isEmpty) {
                                return Container();
                              } else {
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
                                          padding: EdgeInsets.all(20),
                                          child: Container(
                                            height: 100,
                                            child: Stack(
                                              children: [
                                                Card(
                                                  elevation: 5,
                                                  color: getStatusColor(status),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Text(
                                                                status,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15,
                                                                  color:
                                                                      getStatusTextColor(
                                                                          status),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            30.0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    AwesomeDialog(
                                                                            context:
                                                                                context,
                                                                            dialogType: DialogType
                                                                                .noHeader,
                                                                            titleTextStyle: TextStyle(
                                                                                color: Colors.red,
                                                                                fontWeight: FontWeight.w900,
                                                                                fontSize: 20),
                                                                            animType: AnimType.rightSlide,
                                                                            title: ' Problème',
                                                                            desc: probleme,
                                                                            btnOkText: "Oui")
                                                                        .show();
                                                                  },
                                                                  child: Text(
                                                                    "voir commentaire",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12,
                                                                      color: getStatusTextColor(
                                                                          status),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(width: 5),
                                                          getStatusIcon(status),
                                                          SizedBox(width: 10),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 110,
                                                          bottom: 80),
                                                  child: Container(
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: getStatusColor(
                                                          status),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      /*border: Border.all(
                                                              //width: 2,
                                                              /*color:
                                                                  getStatusColor(
                                                                      status)*/
                                                              )*/
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Text(
                                                        " Envoyé le: $day /" +
                                                            "$month /" +
                                                            "$year",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255, 19, 89, 188),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
