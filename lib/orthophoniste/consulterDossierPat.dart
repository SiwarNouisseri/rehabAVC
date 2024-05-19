import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/textformfielesRead.dart';
import 'package:first/orthophoniste/PDFApi.dart';
import 'package:first/orthophoniste/pdfViewer.dart';
import 'package:first/patient/dossierMedical.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ConsulterdossierPatient extends StatefulWidget {
  final String idPat;
  const ConsulterdossierPatient({super.key, required this.idPat});

  @override
  State<ConsulterdossierPatient> createState() =>
      _ConsulterdossierPatientState();
}

class _ConsulterdossierPatientState extends State<ConsulterdossierPatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('dossier')
              .where('id patient', isEqualTo: widget.idPat)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while fetching data
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data!.docs.isEmpty) {
                return Container();
              } else {
                var document = snapshot.data!.docs.first;
                var documentid = document.id;
                var reduction =
                    snapshot.data!.docs.first.get('rééduction enligne');
                var age = snapshot.data!.docs.first.get('age');
                var datee = snapshot.data!.docs.first.get('date Avc');
                var type = snapshot.data!.docs.first.get('type Avc');
                var urlLien = snapshot.data!.docs.first.get('url pdf');

                DateTime date = datee.toDate();
                int jour = date.day; // Jour du mois (1-31)
                int mois = date.month; // Mois (1-12)
                int annee = date.year;
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 70.0, right: 70, bottom: 20),
                  child: Container(
                    height: 700,
                    width: 400,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        textFormRead(
                          hinttext: 'Age',
                          text: "$age",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        textFormRead(
                          hinttext: 'Type',
                          text: type,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        textFormRead(
                          hinttext: 'Date',
                          text: "$jour" + "/" + "$mois" + "/" + "$annee",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        textFormRead(
                          hinttext: 'Avoir une réduction en ligne avant ',
                          text: reduction,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final url = urlLien;
                            final file = await PDFApi.loadFirebase(url);

                            if (file == null) return;
                            openPDF(context, file);

                            /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFViewerPage(file: null,
                                  
                                ),
                              ),
                            );*/
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Voir ancien rapport médical",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[300],
                                  fontSize: 15,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.blue[300],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
          }),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
