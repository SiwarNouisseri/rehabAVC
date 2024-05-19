import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorWidget extends StatefulWidget {
  const DoctorWidget({super.key});

  @override
  State<DoctorWidget> createState() => _DoctorWidgetState();
}

class _DoctorWidgetState extends State<DoctorWidget> {
  void updateDocumentField(String docId) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(docId);

    // Update the specific field using the update method
    documentReference.update({
      'etat': 'désactivé',
    }).then((value) {
      print('updated document successd');
    }).catchError((error) {
      print('Failed to update document field: $error');
    });
  }

  /////////////////////fonction de suppression de compte//////////////////
  void deleteUserData(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Delete user from Firebase Authentication
        /* await FirebaseAuth.instance
        .deleteUser(id);*/
        print('User deleted successfully from Firebase Auth');

        // Delete user document from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: id)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
        print('User document deleted successfully from Firestore');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Suppression',
          desc: 'Utilisateur supprimé avec succès',
        ).show();
      } catch (e) {
        print('Error deleting user data: $e');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Suppression',
          desc: 'Essayer une autre fois une erreur a eu lieu ',
        ).show();
      }
    }
  }
  /////////////////////fonction de suppression de compte//////////////////

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
              .orderBy('nom')
              .where('etat', isEqualTo: 'activé') // Tri par nom
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
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
                  var image = document.get('image url');
                  var nom = document.get('nom');
                  var doc = document.id;
                  var prenom = document.get('prenom');
                  var mail = document.get('email');
                  var temps = document.get('Date de creation');
                  var idDoc = document.get('id');
                  var mdp = document.get('mot de passe ');
                  var role = document.get('role');
                  DateTime date = temps.toDate();
                  int jour = date.day; // Jour du mois (1-31)
                  int mois = date.month; // Mois (1-12)
                  int annee = date.year; // Année
                  int heure = date.hour; // Heure (0-23)
                  int minute = date.minute; // Minute (0-59)
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.lightBlue[50],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 800,
                                child: Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        width: 50,
                                        child: CircleAvatar(
                                          radius: 25.0,
                                          backgroundImage: NetworkImage(image),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      height: 150,
                                      width: 250,
                                      child: ListView(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            "Nom :" +
                                                " " +
                                                nom +
                                                "\nPrénom :" +
                                                " " +
                                                prenom,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey[700],
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Email :" + " " + mail,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey[700],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 100,
                                      width: 71,
                                      child: ListView(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 98, 215, 108),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(2)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                role,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  fontSize: 8.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.error,
                                                animType: AnimType.rightSlide,
                                                title: 'Suppression',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  updateDocumentField(doc);
                                                },
                                                desc:
                                                    'Êtes-vous sûr de vouloir supprimer ce compte ?',
                                              ).show();
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  child: Image.asset(
                                                    "images/bin.png",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 200),
                                child: Text(
                                  "Crée le " +
                                      "$jour" +
                                      "/" +
                                      "$mois" +
                                      "/" +
                                      "$annee" +
                                      " " +
                                      "à" +
                                      " "
                                          "$heure" +
                                      ":" +
                                      "$minute",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[300],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                });
          },
        ));
  }
}
