import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/editfield.dart';
import 'package:flutter/material.dart';

class ModifierExercice extends StatefulWidget {
  const ModifierExercice({super.key});

  @override
  State<ModifierExercice> createState() => _ModifierExerciceState();
}

class _ModifierExerciceState extends State<ModifierExercice> {
  @override
  Future<void> editField(
      String field, String value, BuildContext context) async {
    String newValue = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Modifier $value",
            style: const TextStyle(color: Colors.blue),
          ),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.green),
            decoration: InputDecoration(
              hintText: "Entrer $value",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
// cancel button
            TextButton(
              child: Text(
                'Annuler',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context),
            ),

// save button
            TextButton(
              child: Text(
                'Enregistrer',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ]),
    );
    if (newValue.trim().length > 0) {
      // only update if there is something in the textfield
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference users =
          FirebaseFirestore.instance.collection('exercices');

      users
          .where('id de docteur', isEqualTo: user?.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({field: newValue}).then((value) {
            print("updated successfully!");
          }).catchError((error) {
            print("Error updating : $error");
          });
        });
      });
    }
  }

  Future<void> updateExercise(BuildContext context, String exerciseId,
      String newValue1, String newValue2) async {
    CollectionReference exercises =
        FirebaseFirestore.instance.collection('exercices');

    try {
      await exercises
          .doc(exerciseId) // Utilisez doc() avec l'ID de l'exercice spécifique
          .update({
        'description': newValue1,
        'nom': newValue2,
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Succès',
        desc: 'Modification effectuée avec succès',
      ).show();
    } catch (error) {
      print('Erreur lors de la mise à jour : $error');
    }
  }

  final TextEditingController nomContoller = TextEditingController();
  final TextEditingController description = TextEditingController();

//editFields('nom', 'prenom', 'Nouveau Nom', 'Nouveau Prénom', context)
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('exercices')
          .where('id de docteur',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while fetching data
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return Text('Document does not exist on the database');
          } else {
            var desp = snapshot.data!.docs.first.get('description');
            var nom = snapshot.data!.docs.first.get('nom');
            var id = snapshot.data!.docs.first.id;
            print("+++++++++++++++++++++++++" + id);

            return ListView(children: [
              SizedBox(
                height: 45,
              ),
              Center(
                child: Text(
                  "Modifier vos vidéos",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: Colors.blue),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                  height: 100,
                  width: 70,
                  child: Image.asset("images/modifier.png")),
              SizedBox(
                height: 90,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 10),
                child: TextFormField(
                  controller: nomContoller,
                  //initialValue: nom ?? " vide",
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.blue[500] ?? Colors.blue, width: 0.7),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.blue[500] ?? Colors.blue, width: 0.7),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    labelText: "Nom d'exercice",
                    suffix: GestureDetector(
                      onTap: () => editField('bio', 'Biographie', context),
                      child: Image.asset(
                        "images/final.png",
                        width: 20,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 10),
                child: TextFormField(
                  // initialValue: desp ?? " vide",
                  controller: description,
                  maxLines: 10,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.blue[500] ?? Colors.blue, width: 0.7),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.blue[500] ?? Colors.blue, width: 0.7),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(
                      Icons.edit_document,
                      color: Colors.blue,
                    ),
                    labelText: "Description d'exercice",
                    suffix: GestureDetector(
                      onTap: () => editField('bio', 'Biographie', context),
                      child: Image.asset(
                        "images/final.png",
                        width: 20,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 180,
                    child: MaterialButton(
                      minWidth: 60,
                      height: 40,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      onPressed: () async {
                        await updateExercise(
                            context, id, description.text, nomContoller.text);
                        description.clear();
                        nomContoller.clear();
                      },
                      child: Text(
                        "Modifier ",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
          }
        }
      },
    ));
  }
}
