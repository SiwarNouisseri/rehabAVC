import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/messOrtho.dart';
import 'package:first/orthophoniste/messagerie/messagerieOrtho.dart';
import 'package:flutter/material.dart';

class docMess extends StatefulWidget {
  const docMess({Key? key}) : super(key: key);

  @override
  State<docMess> createState() => _docMessState();
}

class _docMessState extends State<docMess> {
  Future<String?> checkExistingconversation(String idDoc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('conversation')
        .where('id de docteur', isEqualTo: idDoc)
        .where('id de patient',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Renvoyer l'ID du premier document trouvé
      return querySnapshot.docs.first.id;
    } else {
      // Aucun document trouvé, renvoyer null
      return null;
    }
  }

  Future<void> updateMessages(String conversationId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('message')
          .where('id conver ', isEqualTo: conversationId)
          .where("recepteur", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var document in querySnapshot.docs) {
        await document.reference.update({
          'statut': 'vu',
        });
      }

      print('Champs mis à jour avec succès.');
    } catch (e) {
      print('Erreur lors de la mise à jour des champs : $e');
    }
  }

  Future<String> addconverDetails(String idDoc) async {
    try {
      DateTime now = DateTime.now();
      String dateNow = '${now.year}-${now.month}-${now.day}';
      String timeNow = '${now.hour}:${now.minute}:${now.second}';

      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('conversation').add({
        'id de patient': FirebaseAuth.instance.currentUser?.uid,
        'id de docteur': idDoc,
        'Date de creation': dateNow,
        'Heure de creation': timeNow,
      });

      return documentReference.id; // Retourner l'ID du document ajouté
    } catch (e) {
      print('Error adding conversation details: $e');
      // Gérer l'erreur selon vos besoins
      return ''; // Retourner une chaîne vide en cas d'erreur
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
                borderSide: BorderSide(color: Colors.blue[300] ?? Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.blue ?? Colors.blue),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Rechercher',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('suivi')
            .where('id de patient',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where("status", isEqualTo: "acceptée")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              print('Document does not exist on the database');
              return Container(
                width: 370,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.amber,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image.asset(
                        "images/time-left.png",
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Attendez jusqu'à obtenir des patients ",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                height: 200,
                width: 400,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data!.docs[index];
                    var idDoc = document.get('id de docteur');

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .orderBy('nom') // Tri par nom
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        List<DocumentSnapshot> doctors = snapshot.data!.docs;
                        List<DocumentSnapshot> filteredDoctors =
                            doctors.where((doc) {
                          var id = doc.get('id');
                          var nom = doc.get('nom');
                          var prenom = doc.get('prenom');
                          var searchText = searchController.text.toLowerCase();
                          return (id == idDoc) &&
                              (nom.toLowerCase().contains(searchText) ||
                                  prenom.toLowerCase().contains(searchText));
                        }).toList();

                        return Container(
                          width: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredDoctors.length,
                            itemBuilder: (BuildContext context, int index) {
                              var document = filteredDoctors[index];
                              var image = document.get('image url');
                              var nom = document.get('nom');
                              var prenom = document.get('prenom');
                              var idPat = document.get('id');

                              var patient = prenom + " " + nom;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  bottom: 10,
                                  top: 10,
                                ),
                                child: Row(
                                  children: [
                                    //insertion de firestore
                                    InkWell(
                                      onTap: () async {
                                        String? idConver =
                                            await checkExistingconversation(
                                                idPat);

                                        if (idConver == null ||
                                            idConver.isEmpty) {
                                          idConver =
                                              await addconverDetails(idPat);
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Messagerie(
                                                patient: patient,
                                                image: image,
                                                idConver: idConver ?? '',
                                                idPatient: idPat),
                                          ),
                                        );
                                        updateMessages(idConver);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CircleAvatar(
                                            radius: 34.0,
                                            backgroundImage:
                                                NetworkImage(image),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            prenom,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 20),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
