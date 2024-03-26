import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResetErgo extends StatefulWidget {
  const ResetErgo({Key? key}) : super(key: key);

  @override
  State<ResetErgo> createState() => _ResetErgoState();
}

class _ResetErgoState extends State<ResetErgo> {
  final currentPass = TextEditingController();
  final newPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> updatePasswordInFirestore(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users.where('id', isEqualTo: user?.uid).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'mot de passe ': newPassword}).then((value) {
          print("updated successfully!");
        }).catchError((error) {
          print("Error updating : $error");
        });
      });
    });
  }

  Future<void> updateFirebasePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.updatePassword(newPassword);
      print("Password updated in Firebase Authentication successfully!");
    } catch (e) {
      print("Error updating password in Firebase Authentication: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                SizedBox(
                  height: 40,
                ),
                Image.asset("images/reinitialiser-le-mot-de-passe.png",
                    width: 120),
                SizedBox(
                  height: 40,
                ),
                const Text('Réinitialiser le mot de passe',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return " champs vide ";
                      }
                    },
                    obscureText: true,
                    controller: currentPass,
                    decoration: const InputDecoration(
                      hintText: 'Mot de passe actuel',
                      prefixIcon: Icon(Icons.lock_person_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return " champs vide ";
                      }
                    },
                    obscureText: true,
                    controller: newPass,
                    decoration: const InputDecoration(
                      hintText: 'Nouveau mot de passe',
                      prefixIcon: Icon(
                        Icons.lock_reset_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaterialButton(
                    color: Colors.greenAccent[700],
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Validez le formulaire ici
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: FirebaseAuth.instance.currentUser!.email!,
                            password: currentPass.text,
                          );

                          // Update password in Firebase Authentication
                          await updateFirebasePassword(newPass.text);

                          // Update password in Firestore
                          await updatePasswordInFirestore(newPass.text);

                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.bottomSlide,
                            title: 'Succès',
                            desc: 'Mot de passe mis à jour avec succès',
                            btnOkOnPress: () {},
                          )..show();

                          currentPass.clear();
                          newPass.clear();
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.bottomSlide,
                              title: 'Erreur',
                              desc:
                                  'Les données saisies sont incorrectes, mal formées ou ont expiré',
                              btnCancelOnPress: () {},
                            )..show();
                            currentPass.clear();
                            newPass.clear();
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Mettre à jour ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
