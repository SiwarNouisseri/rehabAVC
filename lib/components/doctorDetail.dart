import 'package:flutter/material.dart';

class DetailDoctor extends StatelessWidget {
  final String nom;
  final String specialiste;
  final String image;

  const DetailDoctor({
    Key? key,
    required this.nom,
    required this.specialiste,
    required this.image,
    required onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Column(children: [
                    Text(
                      nom,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey[700],
                        fontSize: 17,
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
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
