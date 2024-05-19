import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReclamWidget extends StatefulWidget {
  const ReclamWidget({Key? key}) : super(key: key);

  @override
  State<ReclamWidget> createState() => _ReclamWidgetState();
}

class _ReclamWidgetState extends State<ReclamWidget> {
  Color getStatusColor(DateTime date) {
    DateTime now = DateTime.now();

    // Comparer les dates en ne considérant que le jour, le mois et l'année
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return Colors.blue[50] ?? Colors.blue; // Couleur pour la date actuelle
    } else {
      return Colors.grey[50] ?? Colors.grey; // Couleur pour une date future
    }
  }

  String gettextNow(DateTime date) {
    int jour = date.day;
    int mois = date.month;
    int annee = date.year;
    int heure = date.hour;
    int minute = date.minute;
    DateTime now = DateTime.now();
    int heureN = now.hour;
    int minuteN = now.minute;
    // Comparer les dates en ne considérant que le jour, le mois et l'année
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Aujourd'hui à " +
          "$heure" +
          ":" +
          "$minute"; // Couleur pour la date actuelle
    } else {
      return "Envoyé le " +
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
          "$minute"; // Couleur pour une date future
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reclamation')
            .orderBy('envoyeé le', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              return Text('Document does not exist in the database');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data!.docs[index];
                  var contenu = document.get('réclamation');
                  var temps = document.get('envoyeé le');
                  var id = document.get("id d'envoyeur");
                  print("*********************$index");
                  DateTime date = temps.toDate();
                  int jour = date.day;
                  int mois = date.month;
                  int annee = date.year;
                  int heure = date.hour;
                  int minute = date.minute;
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('id', isEqualTo: id)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Text(
                              'Document does not exist in the database');
                        } else {
                          var document = snapshot.data!.docs.first;
                          var image = document.get('image url');
                          var prenom = document.get('prenom');
                          var nom = document.get('nom');

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20),
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
                                  child: Card(
                                    color: getStatusColor(date),
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.indigo,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      splitBioText(contenu),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .blueGrey[700],
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
                                          padding:
                                              const EdgeInsets.only(left: 200),
                                          child: Text(
                                            gettextNow(date),
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
                                ),
                              ],
                            ),
                          );
                          ;
                        }
                      }
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  String splitBioText(String bioText) {
    List<String> parts = bioText.split(RegExp(r'[,]'));
    return parts.join('\n');
  }
}
