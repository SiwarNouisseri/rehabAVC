import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/orthophoniste/messageOrtho.dart';
import 'package:first/orthophoniste/notificationOrtho.dart';
import 'package:flutter/material.dart';

class AjouterEx extends StatefulWidget {
  const AjouterEx({Key? key}) : super(key: key);

  @override
  State<AjouterEx> createState() => _AjouterExState();
}

class _AjouterExState extends State<AjouterEx> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.amber,
    ));
  }
}
