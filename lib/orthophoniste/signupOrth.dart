import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/button.dart';
import 'package:first/components/textformfield.dart';
import 'package:flutter/material.dart';

class SignupOrtho extends StatefulWidget {
  const SignupOrtho({super.key});

  @override
  State<SignupOrtho> createState() => _SignupState();
}

class _SignupState extends State<SignupOrtho> {
  TextEditingController username = TextEditingController();
  TextEditingController exp = TextEditingController();
  TextEditingController temps = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController Confirmpassword = TextEditingController();
  var selectedSpec = "Orthophoniste";

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    Confirmpassword.dispose();
    bio.dispose();
    exp.dispose();
    surname.dispose();
    temps.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 2),
                      child: Image.asset(
                        "images/neuro.png",
                        width: 300,
                        height: 200,
                      )),
                  Container(height: 5),
                  Text(
                    "Registration",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue[700]),
                  ),
                  Container(height: 30),
                  //input username
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return " champs vide ";
                        }
                      },
                      hinttext: 'Nom ',
                      mycontroller: username,
                      icon: Icon(Icons.person_4_outlined)),
                  Container(height: 20),
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return " champs vide ";
                        }
                      },
                      hinttext: 'Prénom',
                      mycontroller: surname,
                      icon: Icon(Icons.person_4_rounded)),

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

                  TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return " champs vide ";
                      }
                    },

                    controller: bio,
                    maxLines: 5, // Pour permettre plusieurs lignes de texte
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                            color: Colors.blue[500] ?? Colors.blue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                            color: Colors.blue[700] ?? Colors.blue, width: 1),
                      ),
                      labelText: 'Biographie',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.wallet_membership_outlined,
                          color: Colors.blue[700]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  Container(height: 20),
                  //experience
                  TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return " champs vide ";
                      }
                    },
                    controller: exp,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                            color: Colors.blue[500] ?? Colors.blue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                            color: Colors.blue[700] ?? Colors.blue, width: 1),
                      ),
                      labelText: "Expérience",
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.bar_chart_rounded,
                          color: Colors.blue[700]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
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
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Spécialité:",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.pink),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      DropdownButton(
                        items: ["Orthophoniste", "Ergothérapeute"]
                            .map((e) => DropdownMenuItem(
                                  child: Text("$e"),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedSpec = val!;
                          });
                        },
                        value: selectedSpec,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 20),
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
                      Future addUserDetails(
                          String nom,
                          String email,
                          String spec,
                          String bio,
                          String prenom,
                          String time,
                          int exp,
                          String mdp,
                          String url) async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .add({
                          'nom': nom,
                          'email': email,
                          'role': spec,
                          'bio': bio,
                          'prenom': prenom,
                          'temps': time,
                          'exp': exp,
                          'mot de passe ': mdp,
                          'Date de creation': DateTime.now(),
                          'id': FirebaseAuth.instance.currentUser?.uid,
                          'image url': url
                        });

                        // Set the display name for the user
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await user.updateDisplayName(nom);
                        }
                      }

                      addUserDetails(
                          username.text.trim(),
                          email.text.trim(),
                          selectedSpec,
                          bio.text.trim(),
                          surname.text.trim(),
                          temps.text.trim(),
                          int.parse(exp.text.trim()),
                          password.text.trim(),
                          "none");
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
