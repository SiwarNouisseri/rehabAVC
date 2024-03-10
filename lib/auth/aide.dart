import 'package:first/components/drawer.dart';
import 'package:flutter/material.dart';

class Aide extends StatefulWidget {
  const Aide({super.key});

  @override
  State<Aide> createState() => _AideState();
}

class _AideState extends State<Aide> {
  TextEditingController problem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Aide",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[400],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleSpacing: 100.0,
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "Si vous avez une panne ou une problème technique merci de la déclarer içi :  ",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[500],
                    fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: problem,
              maxLines: 5, // Pour permettre plusieurs lignes de texte
              decoration: const InputDecoration(
                hintText: 'Décrivez votre problème ici ......... ',
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
              color: Colors.blue[400],
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
