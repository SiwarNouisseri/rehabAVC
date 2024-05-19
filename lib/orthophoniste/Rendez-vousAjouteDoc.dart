import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RendAjoute extends StatefulWidget {
  const RendAjoute({super.key});

  @override
  State<RendAjoute> createState() => _RendAjouteState();
}

class _RendAjouteState extends State<RendAjoute> {
  Future<void> removeFollowUpRequest(String idDooc) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('rendez-vous')
          .where('id de docteur',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one matching document, get its reference and delete it

        AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Suppression',
            desc: 'Êtes-vous sûr de vouloir supprimer ce rendez-vous ?',
            btnCancelText: 'Non',
            btnOkText: 'Oui',
            btnCancelOnPress: () {},
            btnOkOnPress: () async {
              DocumentSnapshot docSnapshot = querySnapshot.docs.first;
              await docSnapshot.reference.delete();
            }).show();
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
      stream: FirebaseFirestore.instance
          .collection('rendez-vous')
          .orderBy('date', descending: false)
          .where('id de docteur',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          )); // Show loading indicator while fetching data
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return Text('Document does not exist on the database');
          } else {
            return Column(children: [
              Container(
                  height: 600,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var document = snapshot.data!.docs[index];
                        var idDoc = document.get('id de docteur');
                        var status = document.get('status');
                        var horraire = document.get('date');
                        var heure = document.get('heure');
                        DateTime date = horraire.toDate();
                        int jour = date.day; // Jour du mois (1-31)
                        int mois = date.month; // Mois (1-12)
                        int annee = date.year; // Année
                        //   DateTime now = DateTime.parse(date);
                        DateTime now = DateTime.now();
                        DateTime nowdate = horraire.toDate();

                        return Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Card(
                                  color: Colors.lightBlue[50],
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Container(
                                        width: 400,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                  width: 50,
                                                  child: Image.asset(
                                                      "images/appointment.png")),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              height: 70,
                                              width: 200,
                                              child: ListView(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "rendez-vous " +
                                                        "${index + 1}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.orange[700],
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Le :" +
                                                        "$jour" +
                                                        "/" +
                                                        "$mois" +
                                                        "/" +
                                                        "$annee",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Colors.blueGrey[700],
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    heure,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Colors.blueGrey[700],
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (date.year == now.year &&
                                                date.month == now.month &&
                                                date.day == now.day)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 40.0),
                                                child: Container(
                                                  height: 20,
                                                  width: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(2)),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                      "Aujourd'hui",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (date.year != now.year &&
                                          date.month != now.month &&
                                          date.day != now.day)
                                        Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 320),
                                        child: GestureDetector(
                                          onTap: () =>
                                              removeFollowUpRequest(idDoc),
                                          child: Image.asset(
                                            "images/trash-bin.png",
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      }))
            ]);
          }
        }
      },
    ));
  }
}
