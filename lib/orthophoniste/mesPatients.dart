import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MesPatients extends StatefulWidget {
  const MesPatients({Key? key}) : super(key: key);

  @override
  State<MesPatients> createState() => _MesPatientsState();
}

class _MesPatientsState extends State<MesPatients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Attendez jusqu'à obtenir des patients ",
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
                        var nom = document.get('nom de patient');
                        var image = document.get('image url de patient');
                        var prenom = document.get('prenom de patient');

                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 49.0,
                                backgroundImage: NetworkImage(image),
                              ),
                              Text(nom),
                              Text(prenom),
                              Row(
                                children: [],
                              ),
                            ],
                          ),
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
