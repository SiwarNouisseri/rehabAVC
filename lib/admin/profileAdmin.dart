import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:first/components/editfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({Key? key}) : super(key: key);

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  //get current user doc id
  Future<String?> getCurrentUserDocumentId() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;
        print("++++++++++++++++++++++++" + docId);

        return snapshot.docs.first.id;
      }
    }
    return null; // Return null if document ID not found
  }

//update field
  Future<void> editField(
      String field, String value, BuildContext context) async {
    String newValue = "";
    String? docIdValue = await docId;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Modifier $value",
            style: const TextStyle(color: Colors.blue),
          ),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.green),
            decoration: InputDecoration(
              hintText: "Entrer $value",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
// cancel button
            TextButton(
              child: Text(
                'Annuler',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context),
            ),

// save button
            TextButton(
              child: Text(
                'Enregistrer',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ]),
    );
    if (newValue.trim().length > 0) {
      // only update if there is something in the textfield
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users.where('id', isEqualTo: user?.uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({field: newValue}).then((value) {
            print("updated successfully!");
          }).catchError((error) {
            print("Error updating : $error");
          });
        });
      });
    }
  }

  late Future<String?> imageUrlFuture;

  late Future<String?> docId;

  @override
  void initState() {
    super.initState();
    docId = getCurrentUserDocumentId();
  }

  //the current user
  final currentUser = FirebaseAuth.instance.currentUser;
  //user information
  String userName = "";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? "";

    GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
    return Scaffold(
        key: scaffoldkey,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while fetching data
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data!.docs.isEmpty) {
                return Text('Document does not exist on the database');
              } else {
                var prenom = snapshot.data!.docs.first.get('prenom');
                var mdp = snapshot.data!.docs.first.get('mot de passe ');
                var nom = snapshot.data!.docs.first.get('nom');
                var email = snapshot.data!.docs.first.get('email');
                return ListView(padding: EdgeInsets.zero, children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[400] ?? Colors.blue,
                          Colors.blue[200] ?? Colors.blue,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                      ),
                      color: Colors.blue[300],
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 35.0, right: 35, top: 50),
                      child: Column(
                        children: [
                          Text("Mon Compte",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          SizedBox(height: 20),
                          Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 70,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        height: 400,
                        width: 300,
                        child: ListView(children: [
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0, left: 20.0, bottom: 10),
                            child: Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 20),
                                  Icon(Icons.mail, color: Colors.blue),
                                  SizedBox(width: 40),
                                  Text(
                                    email ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          EditMe(
                            icon: Icons.person_3,
                            title: prenom ?? '',
                            tap: () => editField('prenom', 'Prénom', context),
                          ),
                          EditMe(
                            icon: Icons.person_3_outlined,
                            title: nom ?? '',
                            tap: () => editField('nom', 'Nom', context),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0, left: 20.0, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the sign-up page
                                Navigator.of(context).pushNamed("resetAdmin");
                              },
                              child: Container(
                                width: 300,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Icon(Icons.lock, color: Colors.blue),
                                    SizedBox(width: 40),
                                    Text(
                                      '*' * (mdp?.length ?? 0),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                    Spacer(),
                                    SizedBox(width: 20),
                                    //SizedBox(width: widget.number),
                                    Image.asset(
                                      "images/final.png",
                                      width: 20,
                                    ),

                                    SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )),
                ]);
              }
            }
          },
        ));
  }
}
