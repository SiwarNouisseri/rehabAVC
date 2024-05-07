import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/displayVideoDoc.dart';
import 'package:first/components/envoiMespatient.dart';
import 'package:first/orthophoniste/mesPatients.dart';
import 'package:first/orthophoniste/modifierex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Try extends StatefulWidget {
  const Try({Key? key}) : super(key: key);

  @override
  State<Try> createState() => _TryState();
}

class Exercice {
  final String id;
  final String name;
  final String description;
  final String type;
  final String etat;
  final String url;

  Exercice({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.etat,
    required this.url,
  });
}

class _TryState extends State<Try> {
  late CollectionReference<Map<String, dynamic>> exerciceref;
  final TextEditingController searchController = TextEditingController();
  final Map<String, bool> selectedExercises = {};
  static List<String> selectedExercise = [];

  @override
  void initState() {
    super.initState();

    exerciceref = FirebaseFirestore.instance.collection("exercices");
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 40,
          child: TextFormField(
            controller: searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.blue[300] ?? Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.blue[200] ?? Colors.blue),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              filled: true,
              fillColor: Colors.grey[50] ?? Colors.grey,
              hintText: 'Rechercher',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: exerciceref
            .where('id de docteur',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<DocumentSnapshot> doctors = snapshot.data!.docs;
            List<DocumentSnapshot> filteredDoctors = doctors.where((doc) {
              var nom = doc.get('nom');

              var searchText = searchController.text.toLowerCase();
              return nom.toLowerCase().contains(searchText);
            }).toList();
            return ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                var document = filteredDoctors[index];
                final nom = document.get('nom');
                final url = document.get('urlvideo');
                final description = document.get('description');
                final id = document.id;
                final type = document.get('type');

                bool isSelected =
                    selectedExercises[id] ?? false; // Check for selection

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    color: Colors.grey[50],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(children: [
                            Checkbox(
                              activeColor: Colors.green,
                              value: isSelected, // Set checkbox value
                              onChanged: (value) {
                                setState(() {
                                  selectedExercises[id] = value!;
                                  print("++++++++++++++++$id");
                                  selectedExercise.add(id); // Update selection
                                });
                              },
                            ),
                            Text(
                              "Exercice",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.blueGrey,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              " ${index + 1} : " + " ",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.blueGrey,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              nom,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.blue,
                                fontSize: 15,
                              ),
                            ),
                            Spacer(),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditEx(url: url)),
                                    );
                                  },
                                  child: Row(children: [
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.blueGrey,
                                    ), // Icon
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text('Consulter'),
                                    ),
                                  ]),
                                ),
                                PopupMenuItem(
                                  child: Row(children: [
                                    Icon(
                                      Icons.share,
                                      color: Colors.blueGrey,
                                    ), // Icon
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text('Envoyer'),
                                    ),
                                  ]),
                                ),
                              ],
                              child: Icon(
                                Icons.more_vert,
                                size: 28.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ]),
                          SizedBox(height: 20),
                          //affichage de description
                          Text(
                            description,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ModifierExercice(id: id)),
                                  );
                                  // setState(() {});
                                },
                                child: Image.asset(
                                  "images/edit.png",
                                  width: 25,
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () async {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.question,
                                    animType: AnimType.bottomSlide,
                                    title:
                                        'Vous êtes sûr de supprimer cet exercice ',
                                    btnOkOnPress: () async {
                                      await FirebaseFirestore.instance
                                          .collection('exercices')
                                          .doc(document.id)
                                          .delete();
                                    },
                                  ).show();
                                },
                                child: Image.asset(
                                  "images/binbin.png",
                                  width: 25,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: _buildNavigationButton(context),
    );
  }

  Widget _buildNavigationButton(BuildContext context) {
    bool isAnyChecked = selectedExercises.values.any((isChecked) => isChecked);
    if (isAnyChecked) {
      return FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext builder) {
              return CupertinoPopupSurface(
                child: Container(
                    color: CupertinoColors.white,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 600,
                    child: Container(
                      width: 700,
                      height: 600,
                      child: Column(
                        children: [
                          Container(
                              width: 400,
                              height: 600,
                              child: envoiMesPatient(
                                selectedExercise: selectedExercise,
                              )),
                        ],
                      ),
                    )),
              );
            },
          );
          print("++++++++++++++helooo+++++++++++++++++++++++++");
        },
        child: Icon(
          Icons.share,
          color: Colors.white,
        ),
      );
    } else {
      // Si aucun élément n'est coché, ne pas afficher de bouton
      return Container();
    }
  }
}
