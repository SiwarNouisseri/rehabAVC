import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/patient/drawer.dart';
import 'package:flutter/material.dart';

class Aide extends StatefulWidget {
  const Aide({super.key});

  @override
  State<Aide> createState() => _AideState();
}

class _AideState extends State<Aide> {
  TextEditingController problem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Réclamation",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue[400],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleSpacing: 100.0,
        ),
        drawer: MyDrawer(),
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
                var nom = snapshot.data!.docs.first.get('nom');
                var id = snapshot.data!.docs.first.get('id');
                var image = snapshot.data!.docs.first.get('image url');
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                          "Si vous avez une panne ou une problème technique merci de la déclarer içi :  ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[500],
                              fontSize: 14)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: problem,
                        maxLines: 5, // Pour permettre plusieurs lignes de texte
                        decoration: const InputDecoration(
                          hintText: 'Décrivez votre problème ici ......... ',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Column(children: [
                      MaterialButton(
                        minWidth: 200,
                        color: Colors.blue[400],
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          try {
                            void addReclamDetails() async {
                              await FirebaseFirestore.instance
                                  .collection('reclamation')
                                  .add({
                                'nom ': nom,
                                'prenom ': prenom,
                                'image url': image,
                                'réclamation': problem.text.trim(),
                                'id ': id,
                                'envoyeé le': FieldValue.serverTimestamp(),
                              });
                            }

                            addReclamDetails();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Réclamation envoyée avec succès !',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Clear the text field after sending the complaint
                            problem.clear();
                          } catch (e) {
                            print('Error sending complaint: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Échec  , veuillez réessayer'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text('Envoyer',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]),
                  ],
                );
              }
            }
          },
        ));
  }
}
