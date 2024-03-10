import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/auth/aide.dart';
import 'package:first/auth/profile.dart';
import 'package:first/components/My_listTile.dart';
import 'package:first/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Homepage()));
            },
          ),
          SizedBox(height: 20),
          MyListTile(
            icon: Icons.person_4_rounded,
            title: "Compte",
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profil()));
            },
          ),
          SizedBox(height: 20),
          MyListTile(
            icon: Icons.help_outline_rounded,
            title: "Aide ",
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Aide()));
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
