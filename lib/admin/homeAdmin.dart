import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/admin/notifAdmin.dart';
import 'package:first/admin/profileAdmin.dart';
import 'package:first/admin/welcomeAdmin.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  int selectedindex = 0;
  List<Widget> listWidget = <Widget>[
    WelcomeAdmin(),
    //  NotifAdmin(),
    ProfileAdmin()
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
              /* Icon(
                Icons.notifications,
                color: Colors.white,
              ),*/
              Icon(
                Icons.person,
                color: Colors.white,
              ),
            ],
          ),
        ),
        body: listWidget.elementAt(selectedindex));
  }
}
