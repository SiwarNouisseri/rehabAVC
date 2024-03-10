import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/drawer.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
//the current user
  final currentUser = FirebaseAuth.instance.currentUser;
//user information
  String userName = "";
  int tel = 0;
  @override
  void initState() {
    super.initState();
    _getUserName();
    // Call getUserName function in initState
  }

  Future<void> _getUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          setState(() {
            userName = data['name'] ?? '';
            tel = int.tryParse(data['tel'].toString()) ?? 0;
            print("=============================" + " tel");
          });
        }
      }
    } catch (error) {
      print('=====================Error fetching username: $error');
      // Handle errors appropriately, e.g., display an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text(" Mon Compte",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[400],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleSpacing: 80.0,
      ),
      drawer: MyDrawer(),
      body: Container(
        height: 800,
        child: Stack(
          //on a utiliser le Stack pour un positionnement flexible du Card
          children: [
            // Conteneur d'arrière-plan avec des coins arrondis
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            // Card avec positionnement et ajustements souhaités
            Positioned(
              top: AppBar().preferredSize.height +
                  30.0, // Espace entre le haut du Card et l'appbar
              left: 20.0,
              right: 20.0,
              child: Container(
                height: 650, // Ajustez la hauteur du Card selon vos besoins
                child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0.5,
                    shadowColor: Colors.blue[100],
                    // Contenu du Card
                    child: ListView(
                      children: [
                        //profile picture

                        Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.blue[400],
                        ),
                        SizedBox(height: 100),
                        Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text(
                            "Mes informations :",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.lightBlue,
                              fontSize: 30,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        //user email
                        Text(
                          " E-mail:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          currentUser!.email!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        //username
                        Card(
                          elevation: 5.0,
                          margin: EdgeInsets.all(
                              16.0), // Ajoutez une marge autour de la carte
                          child: Padding(
                            padding: EdgeInsets.all(
                                16.0), // Ajoutez un rembourrage à l'intérieur de la carte
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nom: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  " $userName",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //phone number
                        Text(
                          "Téléphone: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "  $tel",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
