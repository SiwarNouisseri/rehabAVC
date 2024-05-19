import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/patient/voirRendezPatient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MoreABoutDoc extends StatefulWidget {
  final String addresse;
  final String idDoc;
  final String bio;
  final int years;
  final String nom;
  final String prenom;
  final String role;
  final String image;
  final void Function()? onPressed;
  final void Function()? onPress;
  const MoreABoutDoc(
      {super.key,
      required this.bio,
      required this.nom,
      required this.prenom,
      required this.role,
      required this.image,
      required this.years,
      this.onPressed,
      this.onPress,
      required this.addresse,
      required this.idDoc});

  @override
  State<MoreABoutDoc> createState() => _MoreABoutDocState();
}

class _MoreABoutDocState extends State<MoreABoutDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[400],
          title: Text(
            ' Détail Médecin ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          titleSpacing: 10,
        ),
        body: ListView(children: [
          Container(
              height: 200,
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
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Image.network(
                    widget.image,
                    width: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Column(children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Dr." + " " + widget.nom + " " + widget.prenom,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      Text(
                        widget.role,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.amber[400]),
                      ),
                      const SizedBox(height: 20),
                      /*Padding(
                        padding: EdgeInsets.only(right: 22),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              color: Colors.indigo,
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.temps,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.indigo),
                            ),
                          ],
                        ),
                      ),
                      */
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 2),
                          Text(
                            widget.addresse,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Colors.indigo),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 35.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              color: Colors.indigo,
                            ),
                            SizedBox(width: 2),
                            Text(
                              "+ " + widget.years.toString() + "ans Expérience",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.indigo),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              )),
          Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.blue[50] ?? Colors.amber,
                ], // Couleurs du dégradé
                begin: Alignment.topLeft, // Position de départ du dégradé
                end: Alignment.bottomLeft, // Position d'arrêt du dégradé
              ),
              color: Colors.blue[300],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 100, right: 60),
              child: Container(
                decoration: BoxDecoration(
                    //color: Colors.blue[50],
                    borderRadius: const BorderRadius.all(Radius.circular(80))),
                child: Row(
                  children: [
                    Text(
                      "    Avis des patients",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Colors.blue[900]),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 15,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 20.0, bottom: 5, right: 20.0),
            child: Text(
              "Bioghraphie :",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Colors.blue[800]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              widget.bio,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Column(children: [
                MaterialButton(
                    minWidth: 20,
                    color: const Color.fromARGB(255, 35, 197, 40),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular((90))),
                    child: Text("Demander un suivi",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white)),
                    onPressed: widget.onPressed),
              ]),
              SizedBox(
                width: 20,
              ),
              Column(children: [
                MaterialButton(
                    minWidth: 20,
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular((90))),
                    child: Text("Annuler un suivi",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white)),
                    onPressed: widget.onPress),
              ]),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Les rendez-vous disponibles :",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: Colors.blue[800])),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 400,
            width: 500,
            child: VoirRendazPatient(
              idDoc: widget.idDoc,
            ),
          ),
        ]));
  }
}
