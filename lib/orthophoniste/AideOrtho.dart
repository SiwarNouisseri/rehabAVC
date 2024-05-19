import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/drawerOrth.dart';
import 'package:first/patient/drawer.dart';
import 'package:flutter/material.dart';

class AideOrtho extends StatefulWidget {
  const AideOrtho({super.key});

  @override
  State<AideOrtho> createState() => _AideState();
}

class _AideState extends State<AideOrtho> {
  String? textVal;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController problem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Réclamation",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue[400],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleSpacing: 70.0,
        ),
        drawer: MyDrawerOrtho(),
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
                var id = snapshot.data!.docs.first.get('id');

                return ListView(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[400] ?? Colors.blue,
                            Colors.blue[200] ?? Colors.blue,
                          ], // Couleurs du dégradé
                          begin: Alignment
                              .topLeft, // Position de départ du dégradé
                          end: Alignment
                              .bottomLeft, // Position d'arrêt du dégradé
                        ),
                        color: Colors.blue[300],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue
                                .withOpacity(0.3), // Couleur de l'ombre
                            spreadRadius: 3, // Rayon de diffusion de l'ombre
                            blurRadius: 8, // Rayon de flou de l'ombre
                            offset: Offset(0, 3), // Décalage de l'ombre
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                        height: 120,
                        width: 150,
                        child: Image.asset("images/negative-comment.png")),
                    Container(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          "Si vous avez une panne ou un problème technique merci de la déclarer ici  ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[400],
                              fontSize: 15)),
                    ),
                    Container(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formState,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Champs vide";
                            }
                          },
                          controller: problem,
                          maxLines:
                              5, // Pour permettre plusieurs lignes de texte
                          decoration: const InputDecoration(
                            hintText: 'Décrivez votre problème ici .........',
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Column(children: [
                      Container(
                        width: 150,
                        height: 45,
                        child: MaterialButton(
                          color: Colors.red[400],
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular((40))),
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            if (formState.currentState!.validate()) {
                              try {
                                void addReclamDetails() async {
                                  await FirebaseFirestore.instance
                                      .collection('reclamation')
                                      .add({
                                    'réclamation': problem.text.trim(),
                                    "id d'envoyeur": id,
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
                                    content:
                                        Text('Échec  , veuillez réessayer'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text('Envoyer',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800)),
                        ),
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
