import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/admin/homeAdmin.dart';
import 'package:first/ergotherapeute/homeErgo.dart';
import 'package:first/homepage.dart';
import 'package:first/orthophoniste/homertho.dart';
import 'package:flutter/material.dart';

class RoleChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          )); // Show loading indicator while fetching data
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return Text('Document does not exist on the database');
          } else {
            var role = snapshot.data!.docs.first.get('role');
            if (role == "Orthophoniste" || role == "Ergothérapeute") {
              return HomeOrtho();
            } else if (role == "patient") {
              return Homepage();
            } else if (role == "admin") {
              return HomeAdmin();
            } /*else if (role == "Ergothérapeute") {
              return HomeErgo();
            }*/
            else {
              return Text('Unknown role');
            }
          }
        }
      },
    ));
  }
}
