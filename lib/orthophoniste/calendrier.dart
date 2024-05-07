import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/displayVideoDoc.dart';
import 'package:first/orthophoniste/modifierex.dart';
import 'package:flutter/material.dart';

class ChecklistItem {
  String name;

  bool isChecked;

  ChecklistItem({required this.name, this.isChecked = false});
}

class CalendrierOrtho extends StatefulWidget {
  @override
  _CalendrierOrthoState createState() => _CalendrierOrthoState();
}

class _CalendrierOrthoState extends State<CalendrierOrtho> {
  late CollectionReference<Map<String, dynamic>> exerciceref;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    exerciceref = FirebaseFirestore.instance.collection("exercices");
  }

  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final List<ChecklistItem> checklist = [
    ChecklistItem(name: 'Item 3'),
  ];

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
              return Container(
                height: 400,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      var document = filteredDoctors[index];
                      final nom = document.get('nom');
                      final url = document.get('urlvideo');
                      final description = document.get('description');
                      final id = document.id;

                      return Column(
                        children: [
                          Container(
                            width: 400,
                            height: 200,
                            child: ListView.builder(
                              itemCount: checklist.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                ChecklistItem item = checklist[index];
                                return Card(
                                  color: Colors.grey[50],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
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
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: item.isChecked,
                                                  onChanged: (value) {
                                                    // Mettre à jour l'état de vérification de l'élément
                                                    item.isChecked = value!;
                                                    // Mettre à jour l'interface utilisateur lorsque l'état change
                                                    setState(() {});
                                                  },
                                                ),
                                                PopupMenuButton(
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditEx(
                                                                      url:
                                                                          url)),
                                                        );
                                                      },
                                                      child: Row(children: [
                                                        Icon(
                                                          Icons
                                                              .remove_red_eye_outlined,
                                                          color:
                                                              Colors.blueGrey,
                                                        ), // Icon
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0),
                                                          child:
                                                              Text('Consulter'),
                                                        ),
                                                      ]),
                                                    ),
                                                    PopupMenuItem(
                                                      child: Row(children: [
                                                        Icon(
                                                          Icons.share,
                                                          color:
                                                              Colors.blueGrey,
                                                        ), // Icon
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0),
                                                          child:
                                                              Text('Envoyer'),
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
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          description,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ModifierExercice(
                                                              id: id)),
                                                );
                                                // setState(() {});*/
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
                                                  dialogType:
                                                      DialogType.question,
                                                  animType:
                                                      AnimType.bottomSlide,
                                                  title:
                                                      'Vous êtes sûr de supprimer cet exercice ',
                                                  btnOkOnPress: () async {
                                                    await FirebaseFirestore
                                                        .instance
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
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }
          }),
      floatingActionButton: _buildNavigationButton(),
    );
  }

  Widget _buildNavigationButton() {
    bool isAnyChecked = checklist.any((item) => item.isChecked);
    if (isAnyChecked) {
      return FloatingActionButton(
        onPressed: () {
          // Action à effectuer lors du clic sur le bouton de navigation
          // Navigator.push(...);
        },
        child: Icon(Icons.navigate_next),
      );
    } else {
      // Si aucun élément n'est coché, ne pas afficher de bouton
      return Container();
    }
  }
}
