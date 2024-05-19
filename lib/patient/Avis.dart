import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/avisContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Avis extends StatefulWidget {
  final String prenom;
  final String idDoc;
  final String image;
  const Avis(
      {super.key,
      required this.prenom,
      required this.image,
      required this.idDoc});

  @override
  State<Avis> createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  TextEditingController problem = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  double _rating = 0;
  Future addUserDetails(
    double evaluate,
    String idDoc,
    String commentaire,
  ) async {
    await FirebaseFirestore.instance.collection('évaluation').add({
      'commentaire': commentaire,
      'evaluation': evaluate,
      'id de docteur': idDoc,
      'Date d envoi': DateTime.now(),
      'id patient': FirebaseAuth.instance.currentUser?.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[400],
          title: Text(
            'Avis des patients',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          titleSpacing: 50,
        ),
        body: ListView(children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[400] ?? Colors.blue,
                  Colors.blue[200] ?? Colors.blue,
                ], // Couleurs du dégradé
                begin: Alignment.topLeft, // Position de départ du dégradé
                end: Alignment.bottomLeft, // Position d'arrêt du dégradé
              ),
              color: Colors.blue[300],
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3), // Couleur de l'ombre
                  spreadRadius: 3, // Rayon de diffusion de l'ombre
                  blurRadius: 8, // Rayon de flou de l'ombre
                  offset: Offset(0, 3), // Décalage de l'ombre
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Column(
            children: [
              Text(
                "Évaluez " + widget.prenom,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.blue[800]),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.image,
                  width: 190,
                  height: 170,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          // SizedBox(height: 2),
          Container(
              height: 250,
              width: 400,
              child: AvisContainer(idDoc: widget.idDoc)),
          Padding(
            padding:
                EdgeInsets.only(left: 20.0, top: 30.0, bottom: 5, right: 20.0),
            child: Row(
              children: [
                Text(
                  "Évaluez :",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.blue),
                ),
                SizedBox(width: 7),
                RatingBar.builder(
                  initialRating: 0,
                  itemSize: 20,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                      print("++++++++++++++++++++++++++++++$_rating");
                    });
                  },
                )
              ],
            ),
          ),
          Form(
            key: formState,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Champs vide";
                  }
                },
                controller: problem,
                maxLines: 2, // Pour permettre plusieurs lignes de texte
                decoration: const InputDecoration(
                  hintText: 'Ecrivez ici ......... ',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Column(children: [
            MaterialButton(
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular((90))),
              color: Colors.blue,
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                if (formState.currentState!.validate()) {
                  try {
                    addUserDetails(_rating, widget.idDoc, problem.text.trim());
                    problem.clear();
                  } catch (e) {
                    print('Error sending complaint: $e');
                  }
                }
              },
              child: Text('Envoyer',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ]),
        ]));
  }
}
