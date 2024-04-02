import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/orthophoniste/messageOrtho.dart';
import 'package:first/orthophoniste/notificationOrtho.dart';
import 'package:first/orthophoniste/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeOrtho extends StatefulWidget {
  const HomeOrtho({super.key});

  @override
  State<HomeOrtho> createState() => _HomeOrthoState();
}

class _HomeOrthoState extends State<HomeOrtho> {
  @override
  int selectedindex = 0;
  List<Widget> listWidget = <Widget>[
    WelcomePage(),
    NotifOrtho(),
    MessOrtho(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 100,
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
