import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/patient/Avis.dart';
import 'package:flutter/material.dart';

class DetailDoctor extends StatelessWidget {
  final String nom;
  final String specialiste;
  final String image;
  final String idDoc;

  const DetailDoctor({
    Key? key,
    required this.nom,
    required this.specialiste,
    required this.image,
    required onPressed,
    required this.idDoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<double> calculateAverageRating(String id) async {
      double averageRating = 0.0;
      int count = 0;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('évaluation').get();

      querySnapshot.docs.forEach((doc) {
        if (doc.id == id) {
          count++;
          // Suppose 'evaluation' is the field in your document containing the evaluation value
          averageRating += doc['evaluation'];
        }
      });

      if (count != 0) {
        averageRating /= count;
      }

      return averageRating;
    }

    return Padding(
      padding: EdgeInsets.only(left: 15, top: 20),
      child: Container(
        height: 121,
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.blue,
            width: 0.2,
          ),
        ),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      width: 150,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 150,
                    height: 120,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Column(children: [
                          Text(
                            nom,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey[700],
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            specialiste,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[200],
                              fontSize: 17,
                            ),
                          ),
                        ]),
                        Container(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Container(
                            height: 40,
                            width: 30,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white, width: 1.5),
                                  borderRadius: BorderRadius.circular((90))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Avis(
                                      prenom: nom,
                                      image: image,
                                      idDoc: idDoc,
                                    ),
                                  ),
                                );
                              },
                              color: Colors.amber[50],
                              child: Row(
                                children: [
                                  Text("Avis"),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 10,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
