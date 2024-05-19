import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter/cupertino.dart';

class CalendrierOrtho extends StatefulWidget {
  const CalendrierOrtho({
    super.key,
  });

  @override
  State<CalendrierOrtho> createState() => _CalendrierOrthoState();
}

class _CalendrierOrthoState extends State<CalendrierOrtho> {
  @override
  TextEditingController _dateController = TextEditingController();
  TextEditingController _heureController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    TimeRange? _picked = await showTimeRangePicker(
      context: context,
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 12, minute: 0),
      disabledTime: TimeRange(
        startTime: const TimeOfDay(hour: 22, minute: 0),
        endTime: const TimeOfDay(hour: 5, minute: 0),
      ),
      disabledColor: Colors.red.withOpacity(0.5),
      strokeWidth: 4,
      ticks: 24,
      ticksOffset: -7,
      ticksLength: 15,
      ticksColor: Colors.grey,
      labels: [
        "12 am",
        "3 am",
        "6 am",
        "9 am",
        "12 pm",
        "3 pm",
        "6 pm",
        "9 pm",
      ].asMap().entries.map((e) {
        return ClockLabel.fromIndex(
          idx: e.key,
          length: 8,
          text: e.value,
        );
      }).toList(),
      labelOffset: 35,
      rotateLabels: false,
      padding: 60,
    );

    if (_picked != null) {
      setState(() {
        _timeOfDay = _picked
            .startTime; // Utilisez _picked.start ou _picked.end selon votre besoin

        _heureController.text =
            'Début: ${_timeOfDay.hour}:${_timeOfDay.minute} - Fin: ${_picked.endTime.hour}:${_picked.endTime.minute}';
      });
    }
  }

  Future addUserDetails(String id) async {
    DateTime date = DateTime.parse(_dateController.text);

    await FirebaseFirestore.instance.collection('rendez-vous').add({
      'id de docteur': FirebaseAuth.instance.currentUser!.uid,
      'id patient': '',
      'date': date,
      'heure': _heureController.text.trim(),
      'status': "Non pris",
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
      body: Form(
        key: formKey,
        child: ListView(
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
                  padding: const EdgeInsets.only(left: 80, top: 30),
                  child: Text(
                    "Fixer un rendez-vous",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 25),
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            /* Center(
              child: Text("Fixer un Rendez-vous",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo,
                      fontSize: 23)),
            ),*/
            SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: 100,
              child: Image.asset("images/appointment (2).png"),
            ),
            /* Column(
              children: [
                Container(
                  width: 150,
                  child: CircleAvatar(
                      radius: 65.0, backgroundImage: NetworkImage(widget.image)),
                ),
              ],
            ),*/
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
            SizedBox(
              height: 30,
            ),
            Column(children: [
              Text("Date :",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                      fontSize: 23)),
              Column(
                children: [
                  Container(
                    width: 280,
                    child: Padding(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Champs vide";
                            }
                          },
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
            Column(children: [
              Text("Heure :",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                      fontSize: 23)),
              Column(
                children: [
                  Container(
                    width: 280,
                    child: Padding(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Champs vide";
                            }
                          },
                          controller: _heureController,
                          decoration: InputDecoration(
                            hintText: 'HEURE',
                            filled: true,
                            fillColor: Colors.blue[50],
                            prefixIcon: Icon(Icons.timer),
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
                      child: Text("Valider",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
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
                                    'Date déjà dépassé',
                                    style: TextStyle(
                                        color: Colors.blueGrey[700],
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            );
                          } else {
                            // Ajouter un nv RDV

                            addUserDetails(
                                FirebaseAuth.instance.currentUser!.uid);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendrierOrtho()),
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Ajout',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    'Rendez-vous ajouté avec succès',
                                    style: TextStyle(
                                        color: Colors.blueGrey[700],
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            );
                          }
                        } else {
                          AwesomeDialog(
                                  context: context,
                                  animType: AnimType.bottomSlide,
                                  desc: 'Champs invalides',
                                  dialogType: DialogType.error,
                                  title: 'Erreur')
                              .show();
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
      ),
    );
  }
}
