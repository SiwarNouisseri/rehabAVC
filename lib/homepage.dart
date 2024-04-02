import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/patient/MessPatient.dart';
import 'package:first/patient/NotifPatient.dart';
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
    NotifPatient(),
    MessPatient(),
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
                Icons.notifications,
                color: Colors.white,
              ),
              Icon(
                Icons.message,
                color: Colors.white,
              ),
            ],
          ),
        ),
        body: listWidget.elementAt(selectedindex));
  }
}
