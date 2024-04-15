import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/patient/MessPatient.dart';
import 'package:first/patient/NotifPatient.dart';
import 'package:first/patient/afficheRendez.dart';
import 'package:first/patient/contacterspec.dart';
import 'package:first/patient/doctor.dart';
import 'package:first/patient/mesDemades.dart';
import 'package:first/patient/welcomePatient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  int selectedindex = 0;
  List<Widget> listWidget = <Widget>[
    WelcomePatient(),
    MesDemandes(),
    Contacter(),
    NotifPatient(),
    AfficheRendez()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 70,
          width: 200,
          child: CurvedNavigationBar(
            height: 50,
            color: Colors.blue[300] ?? Colors.blue,
            animationCurve: Curves.linear,
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.white,
            buttonBackgroundColor: Colors.blue[200] ?? Colors.blue,
            onTap: (val) {
              setState(() {
                selectedindex = val;
              });
            },
            index: selectedindex,
            items: [
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
              ),
              Icon(
                Icons.search_sharp,
                color: Colors.white,
              ),
              Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              Icon(
                Icons.date_range_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ),
        body: listWidget.elementAt(selectedindex));
  }
}
