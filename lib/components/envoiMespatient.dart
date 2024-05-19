import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/AddNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class envoiMesPatient extends StatefulWidget {
  final List<String> selectedExercise;
  envoiMesPatient({
    Key? key,
    required this.selectedExercise,
  }) : super(key: key);

  @override
  State<envoiMesPatient> createState() => _envoiMesPatientState();
}

class _envoiMesPatientState extends State<envoiMesPatient> {
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
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 35,
          child: TextFormField(
            controller: searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue[300] ?? Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue[100] ?? Colors.blue),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              filled: true,
              fillColor: Colors.blue[100],
              hintText: 'Rechercher',
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('suivi')
            .where('id de docteur',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where("status", isEqualTo: "acceptée")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              print('Document does not exist on the database');
              return Container(
                width: 370,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.amber,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image.asset(
                        "images/time-left.png",
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Attendez jusqu'à obtenir des patients ",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data!.docs[index];
                  var idPatient = document.get('id de patient');

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .orderBy('nom') // Tri par nom
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<DocumentSnapshot> doctors = snapshot.data!.docs;
                      List<DocumentSnapshot> filteredDoctors =
                          doctors.where((doc) {
                        var id = doc.get('id');
                        var nom = doc.get('nom');
                        var prenom = doc.get('prenom');
                        var searchText = searchController.text.toLowerCase();
                        return (id == idPatient) &&
                            (nom.toLowerCase().contains(searchText) ||
                                prenom.toLowerCase().contains(searchText));
                      }).toList();

                      return Container(
                        height: 100,
                        width: 400,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredDoctors.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            var document = filteredDoctors[index];
                            var image = document.get('image url');
                            var nom = document.get('nom');
                            var prenom = document.get('prenom');
                            var idPat = document.get('id');

                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Container(
                                height: 100,
                                width: 400,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 1,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    CircleAvatar(
                                      radius: 34.0,
                                      backgroundImage: NetworkImage(image),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      nom,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      prenom,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Spacer(),
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddNote(
                                              selectedExercise:
                                                  widget.selectedExercise,
                                              idPat: idPat,
                                              nom: nom,
                                            ),
                                          ),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.white, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular((70))),
                                      child: Text(
                                        "Envoyer ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      color: Colors.blue[300],
                                    ),
                                    SizedBox(
                                      width: 7,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
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
}
