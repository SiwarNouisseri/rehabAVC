import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Rendez extends StatefulWidget {
  final String nom;
  final String idDoc;
  final String prenom;
  final String image;

  const Rendez(
      {super.key,
      required this.nom,
      required this.image,
      required this.prenom,
      required this.idDoc});

  @override
  State<Rendez> createState() => _RendezState();
}

class _RendezState extends State<Rendez> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _heureController = TextEditingController();
  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  TimeOfDay _timeOfDay = TimeOfDay.now();
  Future<void> _selectTime() async {
    TimeOfDay? _picked =
        await showTimePicker(initialTime: _timeOfDay, context: context);
    if (_picked != null) {
      setState(() {
        _timeOfDay = _picked;

        _heureController.text = _picked.format(context);
      });
    }
  }

  Future addUserDetails(String id) async {
    DateTime date = DateTime.parse(_dateController.text);

    await FirebaseFirestore.instance.collection('rendez-vous').add({
      'id de patient': FirebaseAuth.instance.currentUser!.uid,
      'id de docteur': id,
      'date': date,
      'heure': _heureController.text.trim(),
      'status': "en cours de traitement",
    });
  }

  Future<bool> checkExistingRequest(String idDoctor) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rendez-vous')
        .where('id de docteur', isEqualTo: idDoctor)
        .where('id de patient',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> checkStatueRequest() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rendez-vous')
        .where('status', isEqualTo: "en cours de traitement")
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> removeFollowUpRequest(String idPatient, String idDoctor) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('rendez-vous')
          .where('id de patient', isEqualTo: idPatient)
          .where('id de docteur', isEqualTo: idDoctor)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one matching document, get its reference and delete it
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        await docSnapshot.reference.delete();
        print('Demande de suivi supprimée avec succès');
      } else {
        print('Aucune demande de suivi trouvée pour ce patient');
      }
    } catch (e) {
      print('Erreur lors de la suppression de la demande de suivi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[400] ?? Colors.blue,
                    Colors.blue[200] ?? Colors.blue,
                  ], // Couleurs du dégradé
                  begin: Alignment.topLeft, // Position de départ du dégradé
                  end: Alignment.bottomLeft, // Position d'arrêt du dégradé
                ),
                color: Colors.blue[300],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3), // Couleur de l'ombre
                    spreadRadius: 20, // Rayon de diffusion de l'ombre
                    blurRadius: 100, // Rayon de flou de l'ombre
                    offset: Offset(0, 3), // Décalage de l'ombre
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 50, top: 30),
                child: Text(
                  "Réserver un rendez-vous",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 25),
                ),
              )),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Text("Dr. " + widget.nom + " " + widget.prenom,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo,
                    fontSize: 23)),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                width: 150,
                child: CircleAvatar(
                    radius: 65.0, backgroundImage: NetworkImage(widget.image)),
              ),
            ],
          ),
          /*Center(
            child: Text("Dr. Oumaima Karray",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.blue,
                    fontSize: 23)),
          ),*/
          SizedBox(
            height: 30,
          ),
          Row(children: [
            SizedBox(
              width: 120,
            ),
            Icon(
              CupertinoIcons.phone_circle_fill,
              color: Colors.red,
              size: 38,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Iconsax.message5,
              color: Colors.indigoAccent,
              size: 38,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              CupertinoIcons.videocam_circle_fill,
              color: Colors.green,
              size: 38,
            ),
          ]),
          SizedBox(
            height: 30,
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Text("Date :",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                      fontSize: 23)),
            ),
            Column(
              children: [
                Container(
                  width: 240,
                  child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 10),
                      child: TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          hintText: 'DATE',
                          filled: true,
                          fillColor: Colors.blue[50],
                          prefixIcon: Icon(Icons.calendar_today),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          selectDate();
                        },
                      )),
                ),
              ],
            ),
          ]),
          SizedBox(
            height: 50,
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text("Heure :",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                      fontSize: 23)),
            ),
            Column(
              children: [
                Container(
                  width: 240,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: _heureController,
                        decoration: InputDecoration(
                          hintText: 'HEURE',
                          filled: true,
                          fillColor: Colors.blue[50],
                          prefixIcon: Icon(Icons.calendar_today),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectTime();
                        },
                      )),
                ),
              ],
            ),
          ]),
          SizedBox(
            height: 80,
          ),
          Center(
            child: Column(children: [
              Container(
                height: 40,
                width: 180,
                child: MaterialButton(
                    minWidth: 20,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular((90))),
                    child: Text("Réserver",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white)),
                    onPressed: () async {
                      bool hasExistingRequest = await checkExistingRequest(
                        widget.idDoc,
                      );
                      bool statusRequest = await checkStatueRequest();
                      DateTime parsedDate =
                          DateTime.parse(_dateController.text);

                      if (parsedDate.isBefore(DateTime.now())) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Rappel',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                'Date déjà dispassé',
                                style: TextStyle(
                                    color: Colors.blueGrey[700],
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                      } else if (hasExistingRequest && statusRequest) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Rappel',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                'vous avez déjà un rendez-vous  en attente',
                                style: TextStyle(
                                    color: Colors.blueGrey[700],
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                      } else {
                        // Le patient peut envoyer une nouvelle demande de suivi

                        addUserDetails(widget.idDoc);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Réservation',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                'Réservation valide',
                                style: TextStyle(
                                    color: Colors.blueGrey[700],
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                      }
                    }),
              )
            ]),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
