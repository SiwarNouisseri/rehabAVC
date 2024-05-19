// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/doctorDetail.dart';
import 'package:first/patient/moreaboutDoctor.dart';
import 'package:flutter/material.dart';

class DoctorScroll extends StatefulWidget {
  final String idPatient;

  const DoctorScroll({
    super.key,
    required this.idPatient,
  });

  @override
  State<DoctorScroll> createState() => _DoctorScrollState();
}

class _DoctorScrollState extends State<DoctorScroll> {
  Future<bool> checkExistingFollowUpRequest(
      String idPatient, String idDoctor) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('suivi')
        .where('id de patient', isEqualTo: idPatient)
        .where('id de docteur', isEqualTo: idDoctor)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> removeFollowUpRequest(String idPatient, String idDoctor) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('suivi')
          .where('id de patient', isEqualTo: idPatient)
          .where('id de docteur', isEqualTo: idDoctor)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one matching document, get its reference and delete it
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        await docSnapshot.reference.delete();
        print('Demande de suivi supprimée avec succès');
      } else {
        print('Aucune demande de suivi trouvée pour ce patient');
      }
    } catch (e) {
      print('Erreur lors de la suppression de la demande de suivi: $e');
    }
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
            height: 40,
            child: TextFormField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide:
                      BorderSide(color: Colors.blue[300] ?? Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide:
                      BorderSide(color: Colors.blue[200] ?? Colors.blue),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Colors.grey[50] ?? Colors.grey,
                hintText: 'Rechercher',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('nom') // Tri par nom
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> doctors = snapshot.data!.docs;
            List<DocumentSnapshot> filteredDoctors = doctors.where((doc) {
              var role = doc.get('role');
              var nom = doc.get('nom');
              var prenom = doc.get('prenom');
              var searchText = searchController.text.toLowerCase();
              return (role == 'Orthophoniste' || role == 'Ergothérapeute') &&
                  (nom.toLowerCase().contains(searchText) ||
                      prenom.toLowerCase().contains(searchText));
            }).toList();

            return ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (BuildContext context, int index) {
                var document = filteredDoctors[index];

                var nom = document.get('nom');
                var role = document.get('role');
                var image = document.get('image url');
                var prenom = document.get('prenom');

                var years = document.get('exp');
                var bio = document.get('bio');
                var id = document.get('id');
                var url = document.get('image url');
                var addresse = document.get('addresse');

                return GestureDetector(
                  onTap: () {
                    // Navigate to doctor's detail page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoreABoutDoc(
                            bio: bio,
                            nom: nom,
                            prenom: prenom,
                            role: role,
                            image: image,
                            years: years,
                            onPressed: () async {
                              Future addsuivieDetails() async {
                                await FirebaseFirestore.instance
                                    .collection('suivi')
                                    .add({
                                  'id de patient': widget.idPatient,
                                  'id de docteur': id,
                                  'status': "en cours de traitement",
                                  'envoyé le': FieldValue.serverTimestamp(),
                                  'accepté le': "pas encore"
                                });
                              }

                              bool hasExistingRequest =
                                  await checkExistingFollowUpRequest(
                                      widget.idPatient, id);
                              if (hasExistingRequest) {
                                // Afficher un message ou désactiver le bouton d'envoi de demande
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Rappel',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        'Vous avez déjà une demande de suivi en cours',
                                        style: TextStyle(
                                            color: Colors.blueGrey[700],
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                );

                                print(
                                    'Le patient a déjà une demande de suivi en attente.');
                                // Vous pouvez afficher un message d'erreur à l'utilisateur ici
                              } else {
                                // Le patient peut envoyer une nouvelle demande de suivi
                                addsuivieDetails();

                                // Afficher un message de succès ou effectuer d'autres actions après l'envoi de la demande
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.bottomSlide,
                                  title: 'Succès',
                                  desc: 'Demande de suivi envoyée avec succès',
                                ).show();
                              }
                            },
                            onPress: () async {
                              bool hasExistingRequest =
                                  await checkExistingFollowUpRequest(
                                      widget.idPatient, id);
                              if (hasExistingRequest) {
                                await removeFollowUpRequest(
                                    widget.idPatient, id);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.bottomSlide,
                                  title: 'Suppression',
                                  desc:
                                      'Demande de suivi supprimée avec succès',
                                ).show();
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Suppression',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'Aucune demande de suivi trouvée pour ce patient',
                                          style: TextStyle(
                                              color: Colors.blueGrey[700],
                                              fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    });
                              }
                            },
                            addresse: addresse,
                            idDoc: id,
                          ),
                        ));
                  },
                  child: Row(children: [
                    DetailDoctor(
                      nom: "Dr." + nom + " " + prenom,
                      specialiste: role,
                      image: image,
                      onPressed: null,
                      idDoc: id,
                    ),
                    SizedBox(width: 10),
                  ]),
                );
              },
            );
          },
        ));
  }
}
