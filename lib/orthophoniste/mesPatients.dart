import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/progressionPa.dart';
import 'package:first/patient/progression.dart';
import 'package:flutter/material.dart';

class MesPatients extends StatefulWidget {
  const MesPatients({Key? key}) : super(key: key);

  @override
  State<MesPatients> createState() => _MesPatientsState();
}

class _MesPatientsState extends State<MesPatients> {
  TextEditingController searchController = TextEditingController();

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
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredDoctors.length,
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
                                height: 70,
                                width: 400,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(60)),
                                  color: Colors.blue[50],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      children: [
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
                                            color: Colors.blue,
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
                                            color: Colors.blue,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProgressionPA(
                                                  idpat: idPat,
                                                  nom: prenom,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.arrow_circle_right_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
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
