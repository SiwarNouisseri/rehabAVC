import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first/components/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  File? image;
  static String? url;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      var imagename = basename(image!.path);

      var refStorge = FirebaseStorage.instance.ref(imagename);
      await refStorge.putFile(imageTemporary!);
      url = await refStorge.getDownloadURL();
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("=============== Failed to pick picture :$e");
    }
  }

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
        backgroundColor: Colors.blue[300],
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
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[300] ?? Colors.blue,
                    Colors.blue[50] ?? Colors.blue,
                  ], // Couleurs du dégradé
                  begin: Alignment.topLeft, // Position de départ du dégradé
                  end: Alignment.bottomLeft, // Position d'arrêt du dégradé
                ),
                color: Colors.blue[400],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            // Card avec positionnement et ajustements souhaités
            Positioned(
                top: AppBar().preferredSize.height + 30.0,
                left: 20.0,
                right: 20.0,
                child: Container(
                  height: 650,
                  child: ListView(
                    children: [
                      //profile picture

                      Center(
                        child: Stack(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 140,
                                      height: 140,
                                      child: url != null
                                          ? Image.network(
                                              url!,
                                              width: 128,
                                              height: 128,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'images/avatar.jpeg',
                                              width: 128,
                                              height: 128,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_a_photo_sharp,
                                        color: Colors.pink[400],
                                      ),
                                      onPressed: () {
                                        pickImage();
                                      },
                                    ),
                                    bottom: -8,
                                    left: 90,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /*  SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Mes informations :",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.lightBlue,
                            fontSize: 25,
                          ),
                        ),
                      ),*/

                      SizedBox(height: 50),

                      //user email
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.pink,
                            width: 0.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Icon(Icons.mail_outline, color: Colors.blue),
                            SizedBox(width: 40),
                            Text(
                              currentUser!.email!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(width: 20),
                            Icon(
                              CupertinoIcons.pencil,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.pink,
                            width: 0.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 40),
                            Text(
                              "$userName",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 200),
                            Icon(
                              CupertinoIcons.pencil,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.pink,
                            width: 0.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Icon(Icons.phone, color: Colors.blue),
                            SizedBox(width: 40),
                            Text(
                              "$tel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 240),
                            Icon(
                              CupertinoIcons.pencil,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 250,
                            child: MaterialButton(
                              minWidth: 60,
                              height: 40,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.pink[400] ?? Colors.pink,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular((10))),
                              onPressed: () {},
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Confirmer informations",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue,
                                        )),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
