import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ReclamWidget extends StatefulWidget {
  const ReclamWidget({super.key});

  @override
  State<ReclamWidget> createState() => _ReclamWidgetState();
}

class _ReclamWidgetState extends State<ReclamWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reclamation').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Column(children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var document = snapshot.data!.docs[index];
                        var nom = document.get('nom ');
                        var image = document.get('image url');
                        var prenom = document.get('prenom ');
                        var contenu = document.get('réclamation');
                        var temps = document.get('envoyeé le');
                        var id = document.get('id ');
                        DateTime date = temps.toDate();
                        int jour = date.day; // Jour du mois (1-31)
                        int mois = date.month; // Mois (1-12)
                        int annee = date.year; // Année
                        int heure = date.hour; // Heure (0-23)
                        int minute = date.minute; // Minute (0-59)
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                width: 400,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.lightBlue[50],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 800,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 60.0),
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
                                            height: 200,
                                            width: 250,
                                            child: ListView(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                Text(
                                                  nom + " " + prenom,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blueGrey[700],
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  splitBioText(contenu),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blueGrey[700],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 200),
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
                                  ],
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

  String splitBioText(String bioText) {
    // Split the bio text using comma or period as delimiters
    List<String> parts = bioText.split(RegExp(r'[,]'));

    // Join the parts with a line break
    String result = parts.join('\n');

    return result;
  }
}
