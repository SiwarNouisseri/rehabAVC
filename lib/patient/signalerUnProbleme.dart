import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/homepage.dart';
import 'package:flutter/material.dart';

class Signaler extends StatefulWidget {
  final String documentId;
  const Signaler({super.key, required this.documentId});

  @override
  State<Signaler> createState() => _SignalerState();
}

class _SignalerState extends State<Signaler> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Future<void> updateField(
      String value, String newvalue, String documentId) async {
    FirebaseFirestore.instance
        .collection('progression')
        .doc(documentId)
        .update({value: newvalue})
        .then((value) => print('Champ mis à jour avec succès'))
        .catchError((error) => print('Erreur lors de la mise à jour : $error'));
  }

  TextEditingController problem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signaler une problème",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue[400],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleSpacing: 25.0,
        ),
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
                return Form(
                  key: formkey,
                  child: ListView(
                    children: [
                      Container(
                        height: 50,
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
                      SizedBox(height: 50),
                      Container(
                          height: 150,
                          width: 150,
                          child: Image.asset("images/problem.png")),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
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
                            hintText:
                                "Si vous avez une problème ou des douleurs merci de la déclarer ici........   ",
                            hintStyle: TextStyle(fontSize: 13),
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
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular((90))),
                          color: Colors.blue,
                          padding: EdgeInsets.all(8.0),
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              await updateField(
                                  'status', " Non validé", widget.documentId);
                              await updateField(
                                  'problème', problem.text, widget.documentId);

                              //addReclamDetails();

                              /*ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Problème envoyée avec succès !',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );*/

                              AwesomeDialog(
                                context: context,
                                dialogBackgroundColor: Colors.green[100],
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                headerAnimationLoop: false,
                                desc: 'Problème envoyée avec succès !',
                                btnOkText: "OK",
                                btnOkOnPress: () async {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()),
                                  );
                                },
                              ).show();

                              // Clear the text field after sending the complaint

                              problem.clear();
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogBackgroundColor: Colors.red[100],
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                headerAnimationLoop: false,
                                desc: 'Échec , Champs invalides',
                              ).show();
                            }
                          },
                          child: Text('Signaler',
                              style: TextStyle(color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, top: 40),
                          child: Center(
                            child: Text(
                                "Nb : Merci de bien suivre les instructions des exercices offertes par votre médecin",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ]),
                    ],
                  ),
                );
              }
            }
          },
        ));
  }
}
