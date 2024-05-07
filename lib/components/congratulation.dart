import 'dart:math';

import 'package:first/homepage.dart';
import 'package:first/patient/welcomePatient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiAnimation extends StatefulWidget {
  @override
  _ConfettiAnimationState createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 6));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ConfettiWidget(
            emissionFrequency: 0.3,
            blastDirection: -pi / 2,
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Félicitations pour avoir terminé cet exercice de rééducation ! ",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Card(
                  /* decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue, width: 1)),*/
                  color: Colors.blue,
                  elevation: 20,
                  shadowColor: Colors.amber,
                  surfaceTintColor: Colors.amber,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Chaque pas que vous faites compte énormément dans votre chemin vers la récupération  ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                    height: 200,
                    width: 300,
                    child: Image.asset('images/superhero.png')),
                SizedBox(
                  height: 70,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 155),
                    child: Row(
                      children: [
                        Text(
                          "Terminer mes exercices ",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.purple,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
