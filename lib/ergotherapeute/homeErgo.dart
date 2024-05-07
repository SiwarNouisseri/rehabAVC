import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/ergotherapeute/messErgo.dart';
import 'package:first/ergotherapeute/notifErgo.dart';
import 'package:first/ergotherapeute/welcomeErgo.dart';
import 'package:first/orthophoniste/messagerie/messagerieOrtho.dart';
import 'package:first/orthophoniste/notificationOrtho.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeErgo extends StatefulWidget {
  const HomeErgo({super.key});

  @override
  State<HomeErgo> createState() => _HomeErgoState();
}

class _HomeErgoState extends State<HomeErgo> {
  @override
  int selectedindex = 0;
  List<Widget> listWidget = <Widget>[WelcomeErgo(), NotifErgo(), MessErgo()];

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
