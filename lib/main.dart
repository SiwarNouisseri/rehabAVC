import 'package:first/admin/listePatient.dart';
import 'package:first/admin/listeSpecialiste.dart';
import 'package:first/admin/reclamations.dart';
import 'package:first/admin/resetAdmin.dart';
import 'package:first/auth/Role.dart';
import 'package:first/auth/actorsauth.dart';
import 'package:first/auth/login.dart';
import 'package:first/ergotherapeute/resetergo.dart';
import 'package:first/orthophoniste/ResetPassword.dart';
import 'package:first/patient/ResetPatient.dart';
import 'package:first/patient/profile.dart';
import 'package:first/auth/signup.dart';
import 'package:first/ergotherapeute/homeErgo.dart';
import 'package:first/homepage.dart';
import 'package:first/orthophoniste/homertho.dart';
import 'package:first/orthophoniste/signupOrth.dart';
import 'package:first/patient/docteurSophie.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('==========================User is currently signed out!');
      } else {
        print('=============================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? RoleChecker()
          : Login(),
      routes: {
        "signup": (contexte) => Signup(),
        "login": (contexte) => Login(),
        "homepage": (context) => Homepage(),
        "profil": (context) => Profil(),
        "docteur1": (context) => Docteur1(),
        "actor": (context) => Actor(),
        "signupOrth": (context) => SignupOrtho(),
        "homeOrtho": (context) => HomeOrtho(),
        "homeErgo": (context) => HomeErgo(),
        "reset": (context) => ResetPassword(),
        "resetPatient": (context) => ResetPatient(),
        "resetErgo": (context) => ResetErgo(),
        "resetAdmin": (context) => ResetAdmin(),
      },
    );
  }
}
