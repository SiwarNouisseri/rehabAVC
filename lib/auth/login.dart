// ignore_for_file: prefer_const_constructors

import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/button.dart';
import 'package:first/components/textformfield.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSecurePassword = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      child: ListView(children: [
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
              Container(height: 30),
              Text(
                "Bienvenue",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue[800]),
              ),
              Container(height: 100),
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
                obscureText: _isSecurePassword,
                controller: password,
                decoration: InputDecoration(
                  hintText: 'mot de passe',
                  icon: Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: togglePassword(),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (email.text.trim() == "") {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'champs vide',
                      desc: 'Merci de saisir votre addresse mail',
                    ).show();
                    return;
                  }

                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.text.trim());
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'réinitialisation validé',
                      desc:
                          'Suivez les instructions dans lemail envoyé pour réinitialiser votre mot de passe',
                    ).show();
                  } catch (e) {
                    print(
                        "=======================Erreur lors de la réinitialisation du mot de passe: $e");
                    if (e == 'user-not-found') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'avertissement',
                        desc: 'Merci de saisir un email valide ',
                      ).show();
                    }
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.grey),
                    )),
              ),
              Container(height: 10),
            ],
          ),
        ),
        CustomButton(
          title: 'Connexion',
          onPressed: () async {
            if (formState.currentState!.validate()) {
              try {
                final credential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email.text.trim(), password: password.text);

                if (credential.user!.emailVerified) {
                  Navigator.of(context).pushReplacementNamed("homepage");
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'réinitialisation validé ',
                    desc:
                        'Suivez les instructions dans lemail pour réinitialiser votre mot de passe',
                  ).show();
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'too-many-requests') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Avertissement',
                    desc: 'Compte désactivé pour plusieurs tentatives échouées',
                  ).show();
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Erreur',
                    desc: 'Coordonnées incorrectes',
                  ).show();
                }
              }
            } else {
              print('Non valide');
            }
          },
        ),
        MaterialButton(
          minWidth: 60,
          height: 40,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.blue[700] ?? Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular((90))),
          onPressed: () {
            signInWithGoogle();
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Continuer avec Google",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                )),
            Image.asset("images/google.png", width: 25)
          ]),
        ),
        Container(height: 10),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed("signup");
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Vous n'avez pas un compte ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the sign-up page
                    Navigator.of(context).pushNamed("signup");
                  },
                  child: Text(
                    "Inscrivez-vous ici",
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
      ]),
    ));
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? Icon(Icons.visibility_outlined)
          : Icon(Icons.visibility_off_outlined),
      color: Colors.grey,
    );
  }
}
