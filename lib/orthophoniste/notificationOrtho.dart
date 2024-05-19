import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/auth/currentUser.dart';
import 'package:first/components/notifContainer.dart';
import 'package:first/orthophoniste/drawerOrth.dart';
import 'package:first/orthophoniste/filtreNotifOrtho.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotifOrtho extends StatefulWidget {
  const NotifOrtho({Key? key}) : super(key: key);

  @override
  State<NotifOrtho> createState() => _NotifOrthoState();
}

class _NotifOrthoState extends State<NotifOrtho> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        drawer: MyDrawerOrtho(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                height: 120,
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
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 300.0, top: 5),
                        child: GestureDetector(
                          onTap: () {
                            scaffoldkey.currentState!.openDrawer();
                          },
                          child: Icon(
                            CupertinoIcons.list_dash,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          " Mes notifications",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 25),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Container(height: 800, child: FiltreOrtho()),
            ],
          ),
        ));
  }
}
