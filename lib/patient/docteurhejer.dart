import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

class DoctorHejer extends StatefulWidget {
  const DoctorHejer({super.key});

  @override
  State<DoctorHejer> createState() => _DoctorHejerState();
}

class _DoctorHejerState extends State<DoctorHejer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
        title: Text(
          ' Détail Médecin ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        titleSpacing: 10,
      ),
      body: ListView(
        children: [
          Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[400] ?? Colors.blue,
                    Colors.blue[200] ?? Colors.blue,
                  ], // Couleurs du dégradé
                  begin: Alignment.topLeft, // Position de départ du dégradé
                  end: Alignment.bottomLeft, // Position d'arrêt du dégradé
                ),
                color: Colors.blue[300],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "images/docteur4-removebg.png",
                    width: 218,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Column(children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Dr. Hajer Triki",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      Text(
                        "Ergothérapeute",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.amber[400]),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(right: 22),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              color: Colors.indigo,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "13 PM - 16 PM",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.indigo),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 26.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.group,
                              color: Colors.indigo,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "+90 Patients",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.indigo),
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "+5 ans Expérience",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.indigo),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              )),
          Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.blue[50] ?? Colors.amber,
                ], // Couleurs du dégradé
                begin: Alignment.topLeft, // Position de départ du dégradé
                end: Alignment.bottomLeft, // Position d'arrêt du dégradé
              ),
              color: Colors.blue[300],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(children: [
              SizedBox(
                width: 120,
              ),
              Icon(
                CupertinoIcons.phone_circle_fill,
                color: Colors.red,
                size: 38,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Iconsax.message5,
                color: Colors.indigoAccent,
                size: 38,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                CupertinoIcons.videocam_circle_fill,
                color: Colors.green,
                size: 38,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 20.0, bottom: 5, right: 20.0),
            child: Text(
              "Bioghraphie :",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              "Dr.Hajer Triki , dotée d'une maîtrise exceptionnelle, se démarque par son engagement constant envers l'amélioration de la vie quotidienne de ses patients",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          Column(children: [
            MaterialButton(
                minWidth: 20,
                color: Colors.green[300],
                child: Text("Demander un suivi",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white)),
                onPressed: () {}),
          ]),
          Padding(
            padding:
                EdgeInsets.only(left: 20.0, top: 20.0, bottom: 5, right: 20.0),
            child: Text(
              "Avis des anciens patients :",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(
                    15), // Move the color property to decoration
                border: Border.all(
                  color: Colors.blue, // Set the color of the border
                  width: 0.2, // Set the width of the border
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: AssetImage("images/patient7.jpg"),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Amel Ajmi",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      SizedBox(width: 10),
                      RatingBar.builder(
                          itemSize: 20,
                          initialRating: 5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          }) // RatingBar.builder
                    ],
                  ),
                  Text(
                      "La thérapie avec  Dr. Hajer Triki a été une expérience transformative ")
                ]),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 20.0, top: 20.0, bottom: 5, right: 20.0),
            child: Row(
              children: [
                Text(
                  "Donner votre avis içi :",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.blue),
                ),
                SizedBox(width: 7),
                RatingBar.builder(
                    initialRating: 0,
                    itemSize: 20,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    }) // RatingBar.builder
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              // controller: problem,
              maxLines: 2, // Pour permettre plusieurs lignes de texte
              decoration: const InputDecoration(
                hintText: 'Ecrivez içi ......... ',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Column(children: [
            MaterialButton(
              minWidth: 200,
              color: Colors.green[300],
              padding: EdgeInsets.all(8.0),
              onPressed: () {},
              child: Text('Envoyer', style: TextStyle(color: Colors.white)),
            ),
          ]),
        ],
      ),
    );
  }
}
