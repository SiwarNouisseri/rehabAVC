import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/patient/rendezVous.dart';
import 'package:flutter/material.dart';

class MesDocteurs extends StatefulWidget {
  const MesDocteurs({super.key});

  @override
  State<MesDocteurs> createState() => _MesDocteursState();
}

class _MesDocteursState extends State<MesDocteurs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('suivi')
            .where('id de patient',
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
                    color: Colors.amber),
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
                      "Attendez jusqu'à obtenir des docteurs ",
                      style: TextStyle(
                          color: Colors.teal, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Container(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var document = snapshot.data!.docs[index];
                        var idDoc = document.get('id de docteur');

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('id', isEqualTo: idDoc)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child:
                                      CircularProgressIndicator()); // Show loading indicator while fetching data
                            } else {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.data!.docs.isEmpty) {
                                return Text(
                                    'Document does not exist on the database');
                              } else {
                                var prenom =
                                    snapshot.data!.docs.first.get('prenom');
                                var nom = snapshot.data!.docs.first.get('nom');

                                var image =
                                    snapshot.data!.docs.first.get('image url');
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Rendez(
                                                        nom: nom,
                                                        image: image,
                                                        prenom: prenom,
                                                        idDoc: idDoc,
                                                      )));
                                        },
                                        child: CircleAvatar(
                                          radius: 49.0,
                                          backgroundImage: NetworkImage(image),
                                        ),
                                      ),
                                      Text(nom),
                                      Text(prenom),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
