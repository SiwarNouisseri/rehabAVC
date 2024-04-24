import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/lastMess.dart';
import 'package:first/orthophoniste/messOrtho.dart';
import 'package:flutter/material.dart';

class patientDiss extends StatefulWidget {
  const patientDiss({Key? key}) : super(key: key);

  @override
  State<patientDiss> createState() => _patientDissState();
}

class _patientDissState extends State<patientDiss> {
  bool isYouTheSender(String senderId) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return currentUserId != null && currentUserId == senderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversation')
            .where('id de docteur',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            print("+++++++++++++++++++passed ");
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              print(
                  '++++++++++++++++++++++++++Document does not exist on the database');
              return Container();
            } else {
              return Container(
                height: 700,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data!.docs[index];
                    var idpa = document.get('id de patient');
                    var idConver = document.id;
                    print("+++++++++++++++++++++$idpa");
                    print("+++++++++++++++++++++$idConver");

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('id', isEqualTo: idpa)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              var document = snapshot.data!.docs[index];
                              var image = document.get('image url');
                              var nom = document.get('nom');
                              var prenom = document.get('prenom');
                              var idpat = document.get('id');
                              print("+++++++++++++++++++++++++++$index");
                              String patient = nom + " " + prenom;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                ),
                                child: Column(children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Messagerie(
                                              patient: patient,
                                              image: image,
                                              idConver: idConver,
                                              idPatient: idpa),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage:
                                                NetworkImage(image),
                                          ),
                                        ),
                                        Container(
                                          height: 100,
                                          width: 300,
                                          child: ListView(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(prenom + " " + nom,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              LastMessageWidget(
                                                conversation: idConver,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /*
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage: AssetImage(
                                              "images/patient.jpg"),
                                        ),
                                      ),
                                      Text(
                                        "Vous: Bonjour ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "22:10",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.indigo,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                    ],
                                  ),
                                  
                                   Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage:
                                              AssetImage("images/patient7.jpg"),
                                        ),
                                      ),
                                      Text(
                                        "docteur j'ai une question",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "22:10",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.indigo,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundImage:
                                              AssetImage("images/patient6.jpg"),
                                        ),
                                      ),
                                      Text(
                                        "Aujoud'hui??",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "22:10",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.indigo,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                    ],
                                  ),*/
                                ]),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
