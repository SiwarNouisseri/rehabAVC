import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/consulterDossierPat.dart';
import 'package:first/orthophoniste/voirdossier.dart';
import 'package:first/patient/dossierMedical.dart';
import 'package:flutter/material.dart';

class dossierPatient extends StatefulWidget {
  final String idPat;
  final String nom;
  const dossierPatient({super.key, required this.idPat, required this.nom});

  @override
  State<dossierPatient> createState() => _dossierPatientState();
}

class _dossierPatientState extends State<dossierPatient> {
  void deleteDocument(String idDossier) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('dossier').doc(idDossier);

    // Supprimer le document
    await docRef.delete();

    print('Document supprimé avec succès.');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dossier')
            .where('id patient', isEqualTo: widget.idPat)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while fetching data
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.only(left: 70.0, right: 70, bottom: 20),
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(
                              width: 2,
                              color: Colors.blue[400] ?? Colors.blue)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text("dossier médical non déposé",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue)),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset('images/folder (1).png')),
                              SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              var document = snapshot.data!.docs.first;
              var documentid = document.id;

              return Padding(
                padding:
                    const EdgeInsets.only(left: 70.0, right: 70, bottom: 20),
                child: Container(
                  height: 120,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                          width: 2, color: Colors.blue[400] ?? Colors.blue)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("dossier médical déposé",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[900])),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => voirDossier(
                                            idpat: widget.idPat,
                                            nom: widget.nom,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset('images/attached(1).png')),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              );
            }
          }
        });
  }
}
