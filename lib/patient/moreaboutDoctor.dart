import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MoreABoutDoc extends StatefulWidget {
  final String bio;
  final int years;
  final String nom;
  final String prenom;
  final String role;
  final String image;
  final String temps;
  final void Function()? onPressed;
  final void Function()? onPress;
  const MoreABoutDoc(
      {super.key,
      required this.bio,
      required this.nom,
      required this.prenom,
      required this.role,
      required this.image,
      required this.temps,
      required this.years,
      this.onPressed,
      this.onPress});

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
                      Padding(
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
                      const Padding(
                        padding: EdgeInsets.only(right: 26.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.group,
                              color: Colors.indigo,
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "+" + widget.years.toString() + "ans Expérience",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.indigo),
                          ),
                        ],
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
            child: Row(children: [
              SizedBox(
                width: 120,
              ),
              Icon(
                CupertinoIcons.phone_circle_fill,
                color: Colors.red,
                size: 38,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Iconsax.message5,
                color: Colors.indigoAccent,
                size: 38,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                CupertinoIcons.videocam_circle_fill,
                color: const Color.fromARGB(255, 35, 197, 40),
                size: 38,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 20.0, bottom: 5, right: 20.0),
            child: Text(
              "Bioghraphie :",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Colors.grey),
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
        ]));
  }
}
