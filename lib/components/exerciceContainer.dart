import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first/components/displayVideoDoc.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ExerciceContainer extends StatefulWidget {
  const ExerciceContainer({Key? key}) : super(key: key);

  @override
  State<ExerciceContainer> createState() => _ExerciceContainerState();
}

class _ExerciceContainerState extends State<ExerciceContainer> {
  final TextEditingController searchController = TextEditingController();

  Future<void> removeFollowUpRequest(String idPatient) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('exercices')
          .where('id de docteur',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one matching document, get its reference and delete it
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        await docSnapshot.reference.delete();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Succès',
          desc: 'Demande de suivi supprimée avec succès',
        ).show();
        print('Demande de suivi supprimée avec succès');
      } else {
        print('Aucune demande de suivi trouvée pour ce patient');
      }
    } catch (e) {
      print('Erreur lors de la suppression de la demande de suivi: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                borderSide: BorderSide(color: Colors.blue[300] ?? Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.blue[200] ?? Colors.blue),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
            .collection('exercices')
            .where('id de docteur',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              return Column(
                children: [
                  SizedBox(height: 120),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      "Rien à voir jusqu’à ce que vous téléchargiez des documents",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  Container(
                    width: 20,
                    height: 200,
                    child: Image.asset("images/not-found.png", width: 40),
                  )
                ],
              );
            }
            List<DocumentSnapshot> doctors = snapshot.data!.docs;
            List<DocumentSnapshot> filteredDoctors = doctors.where((doc) {
              var nom = doc.get('nom');

              var searchText = searchController.text.toLowerCase();
              return nom.toLowerCase().contains(searchText);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = filteredDoctors[index];

                  final nom = document.get('nom');
                  final url = document.get('urlvideo');
                  final description = document.get('description');

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      color: Colors.grey[50],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Exercice",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blueGrey,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  " ${index + 1} : " + " ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blueGrey,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  nom,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              description,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditEx()),
                                    );*/
                                  },
                                  child: Image.asset(
                                    "images/edit.png",
                                    width: 25,
                                  ),
                                ),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    "images/binbin.png",
                                    width: 25,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
