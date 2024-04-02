// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/components/doctorDetail.dart';
import 'package:first/patient/moreaboutDoctor.dart';
import 'package:flutter/material.dart';

class DoctorScroll extends StatefulWidget {
  final String idPatient;
  final String urlPatient;
  final String prenomPatient;
  final String nomPatient;

  const DoctorScroll(
      {super.key,
      required this.idPatient,
      required this.urlPatient,
      required this.prenomPatient,
      required this.nomPatient});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('role',
          whereIn: ['Orthophoniste', 'Ergothérapeute']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return Text('Document does not exist on the database');
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var doctor = snapshot.data!.docs[index];
                var nom = doctor.get('nom');
                var role = doctor.get('role');
                var image = doctor.get('image url');
                var prenom = doctor.get('prenom');
                var temps = doctor.get('temps');
                var years = doctor.get('exp');
                var bio = doctor.get('bio');
                var id = doctor.get('id');
                var url = doctor.get('image url');

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
                            temps: temps,
                            years: years,
                            onPressed: () async {
                              Future addsuivieDetails(
                                  String idPatient,
                                  String nomPatient,
                                  String prenomPatient,
                                  String urlPatient) async {
                                await FirebaseFirestore.instance
                                    .collection('suivi')
                                    .add({
                                  'nom de docteur': nom,
                                  'prenom de docteur': prenom,
                                  'image url de docteur': url,
                                  'id de docteur': id,
                                  'status': "en cours de traitement",
                                  'nom de patient': nomPatient,
                                  'prenom de patient': prenomPatient,
                                  'image url de patient': urlPatient,
                                  'id de patient': idPatient,
                                  'envoyeé le': FieldValue.serverTimestamp(),
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
                                addsuivieDetails(
                                  widget.idPatient,
                                  widget.nomPatient,
                                  widget.prenomPatient,
                                  widget.urlPatient,
                                );

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
                          ),
                        ));
                  },
                  child: Row(children: [
                    DetailDoctor(
                      nom: "Dr." + nom + " " + prenom,
                      specialiste: role,
                      image: image,
                      onPressed: null,
                    ),
                    SizedBox(width: 10),
                  ]),
                );
              },
            );
          }
        }
      },
    ));
  }
}
