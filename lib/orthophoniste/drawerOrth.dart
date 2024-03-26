import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/My_listTile.dart';
import 'package:first/orthophoniste/AideOrtho.dart';
import 'package:first/orthophoniste/homertho.dart';
import 'package:first/orthophoniste/profileOrtho.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawerOrtho extends StatelessWidget {
  const MyDrawerOrtho({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue[200],
      child: ListView(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Colors.white,
            ),
          ),
          MyListTile(
            icon: Icons.home,
            title: "Acceuil",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeOrtho()));
            },
          ),
          SizedBox(height: 20),
          MyListTile(
            icon: Icons.person_4_rounded,
            title: "Compte",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileOrtho()));
            },
          ),
          SizedBox(height: 20),
          MyListTile(
            icon: Icons.help_outline_rounded,
            title: "Réclamation",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AideOrtho()));
            },
          ),
          SizedBox(height: 20),
          MyListTile(
            icon: Icons.login_rounded,
            title: "Déconnexion",
            onTap: () async {
              try {
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.disconnect();
              } catch (e) {
                print(
                    "=============Erreur lors de la déconnexion de Google Sign-In: $e");
              }

              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              } catch (e) {
                print(
                    "=====================Erreur lors de la déconnexion de FirebaseAuth: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
