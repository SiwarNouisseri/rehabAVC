import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/button.dart';
import 'package:first/components/textformfield.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController Confirmpassword = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    Confirmpassword.dispose();
    surname.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  Container(
                    height: 20,
                    width: 50,
                    color: Colors.white,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "images/neuro.png",
                        width: 400,
                        height: 200,
                      )),
                  Container(height: 20),
                  Text(
                    "Registration",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue[800]),
                  ),
                  Container(height: 30),
                  //input username
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return " champs vide ";
                        }
                      },
                      hinttext: 'Nom',
                      mycontroller: username,
                      icon: Icon(Icons.person_4_outlined)),
                  Container(height: 20),
                  //input phone
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return " champs vide ";
                        }
                      },
                      hinttext: 'Prénom',
                      mycontroller: surname,
                      icon: Icon(Icons.person_4)),
                  Container(height: 20),

                  //input email
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return " champs vide ";
                        }
                      },
                      hinttext: 'Email',
                      mycontroller: email,
                      icon: Icon(Icons.email_outlined)),
                  Container(height: 20),

                  //input password
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return " champs vide ";
                        }
                      },
                      hinttext: 'Mot de passe',
                      mycontroller: password,
                      icon: Icon(Icons.lock_outline_rounded)),
                  Container(height: 20),
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return " champs vide ";
                        }
                      },
                      hinttext: 'Confirmer le mot de passe',
                      mycontroller: Confirmpassword,
                      icon: Icon(Icons.vpn_key_outlined)),
                  Container(height: 20),
                ],
              ),
            ),
            CustomButton(
                title: 'Inscription',
                onPressed: () async {
                  // une fonction pour confirmer le mot de passe
                  bool passwordconfirmed() {
                    if (password.text.trim() == Confirmpassword.text.trim()) {
                      return true;
                    } else {
                      return false;
                    }
                  }

                  // création de compte ainsi que le compte vec un mot de passe confirmé
                  if (formState.currentState!.validate()) {
                    try {
                      if (passwordconfirmed()) {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text,
                        );
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title:
                              'Les champs de mot de passe ne correspondent pas',
                          desc:
                              'Veuillez vous assurer que la saisie dans les deux champs est identique',
                        ).show();
                      }
                      // une condition de validation de de compte
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      Navigator.of(context).pushReplacementNamed("login");
                      Future addUserDetails(String name, String email,
                          String surname, String mdp, String url) async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .add({
                          'nom': name,
                          'prenom': surname,
                          'email': email,
                          'role': "patient",
                          'Date de creation': DateTime.now(),
                          'id': FirebaseAuth.instance.currentUser?.uid,
                          'mot de passe ': mdp,
                          'image url': url,
                          'etat': " activé"
                        });

                        // Set the display name for the user
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await user.updateDisplayName(name);
                        }
                      }

                      addUserDetails(username.text.trim(), email.text.trim(),
                          surname.text.trim(), password.text.trim(), "none");
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'INFO',
                          desc: 'Mot de passe faible',
                        ).show();
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'INFO',
                          desc: 'addresse email déja utilisé',
                        ).show();
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    print('Non valide');
                  }
                }),
            Container(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("login");
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Avez-vous déja un compte ?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the sign-up page
                        Navigator.of(context).pushNamed("login");
                      },
                      child: Text(
                        "Connectez-vous ici",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
