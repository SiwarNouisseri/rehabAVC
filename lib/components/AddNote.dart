import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final List<String> selectedExercise;
  final String idPat;
  final String nom;
  const AddNote({
    Key? key,
    required this.selectedExercise,
    required this.idPat,
    required this.nom,
  }) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> FormKey = GlobalKey<FormState>();
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

  TextEditingController searchController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter note ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[400],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleSpacing: 70.0,
      ),
      body: Container(
        width: 700,
        height: 800,
        child: Form(
          key: FormKey,
          child: ListView(
            children: [
              Container(
                height: 40,
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
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3), // Couleur de l'ombre
                      spreadRadius: 3, // Rayon de diffusion de l'ombre
                      blurRadius: 8, // Rayon de flou de l'ombre
                      offset: Offset(0, 3), // Décalage de l'ombre
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              Container(
                  height: 100,
                  width: 100,
                  child: Image.asset("images/sticky-note.png")),
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Saisir note :',
                  style: TextStyle(
                      color: Color.fromARGB(255, 238, 109, 100),
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                    validator: (value) {
                      if (value == "") return "Champs vide";
                    },
                    maxLines: 5,
                    controller: _textFieldController,
                    decoration: const InputDecoration(
                      hintText: "Ajouter votre note ici ......",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(
                              10))), // Couleur du texte de l'input
                    )),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Date limite :',
                  style: TextStyle(
                      color: Color.fromARGB(255, 238, 109, 100),
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 80),
                child: Container(
                  width: 240,
                  child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 10),
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          hintText: 'DATE',
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.blue[200],
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        readOnly: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please select a date";
                          }
                        },
                        onTap: () {
                          selectDate();
                        },
                      )),
                ),
              ),
              SizedBox(
                  height:
                      80), // Espacement entre le DateRangePicker et les actions
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 40,
                          width: 120,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular((40))),
                            color: Colors.red[600],
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Annuler',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 40,
                          width: 120,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular((40))),
                            color: Color.fromARGB(255, 12, 204, 18),
                            onPressed: () {
                              if (FormKey.currentState!.validate()) {
                                Future addprogressionDetails(
                                  String id,
                                ) async {
                                  DateTime date =
                                      DateTime.parse(_dateController.text);
                                  for (String idExercice
                                      in widget.selectedExercise) {
                                    await FirebaseFirestore.instance
                                        .collection('progression')
                                        .add({
                                      'id de patient': id,
                                      'id de docteur': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'id exercice': idExercice,
                                      "date d'envoi": DateTime.now(),
                                      'date limite': date,
                                      'note': _textFieldController.text,
                                      'status': "pas encore",
                                      'problème': 'Pas de problème',
                                    });
                                  }
                                }

                                addprogressionDetails(widget.idPat);
                                _textFieldController.clear();
                                _dateController.clear();

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title:
                                      'Exercices envoyés avec succès à ${widget.nom}',
                                ).show();
                              } else {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'Erreur',
                                        desc: 'Champs vide')
                                    .show();
                              }
                              ;
                            },
                            child: Text(
                              'Valider',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
