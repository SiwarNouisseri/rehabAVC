import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/patient/dossierMedical.dart';
import 'package:flutter/material.dart';

class COnsulterDossier extends StatefulWidget {
  const COnsulterDossier({super.key});

  @override
  State<COnsulterDossier> createState() => _COnsulterDossierState();
}

class _COnsulterDossierState extends State<COnsulterDossier> {
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
            .where('id patient',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                child: Container(
                  height: 120,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                          width: 2, color: Colors.blue[400] ?? Colors.blue)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(" Déposer votre dossier médical",
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
                                      builder: (context) => Dossier()));
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                child: Image.asset('images/file.png')),
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
            } else {
              var document = snapshot.data!.docs.first;
              var documentid = document.id;

              return Padding(
                padding:
                    const EdgeInsets.only(left: 70.0, right: 70, bottom: 20),
                child: Container(
                  height: 120,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                          width: 2, color: Colors.blue[400] ?? Colors.blue)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(" Déposer votre dossier médical",
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
                                      builder: (context) => Dossier()));
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                child: Image.asset('images/file.png')),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: ' Suppression de dossier ',
                                      desc:
                                          'Vous êtes sûr de supprimer votre dossier ?',
                                      btnCancelOnPress: () {},
                                      btnCancelText: "Non",
                                      btnOkOnPress: () {
                                        deleteDocument(documentid);
                                      },
                                      btnOkText: "Oui")
                                  .show();
                            },
                            child: Container(
                                height: 30,
                                width: 30,
                                child:
                                    Image.asset('images/recycle-bin (3).png')),
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
