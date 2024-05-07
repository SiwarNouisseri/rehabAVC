import 'package:first/patient/ConsulterProg.dart';
import 'package:first/patient/consulterDossier.dart';
import 'package:first/patient/consulterProgCog.dart';
import 'package:first/patient/consulterProgParole.dart';
import 'package:first/patient/notifContPatient.dart';
import 'package:first/patient/notifExer.dart';
import 'package:flutter/material.dart';

class FilterProg extends StatefulWidget {
  @override
  _FilterProgState createState() => _FilterProgState();
}

class _FilterProgState extends State<FilterProg> {
  bool _isPhysicalSelected = true;
  bool _isCognitiveSelected = false;
  bool _isOtherSelected = false; // Nouveau état pour le troisième chip

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 700,
        width: 700,
        child: Column(
          children: [
            Container(height: 150, width: 400, child: COnsulterDossier()),
            Center(
              child: Text(
                "Compte rendu de mes activités :",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  color: Colors.blue[400],
                ),
              ),
            ),
            Container(
              height: 100,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  children: [
                    FilterChip(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: _isPhysicalSelected
                              ? Colors.white
                              : Colors.blue[900] ??
                                  Colors.blue, // Couleur de la bordure
                          width: 1.0, // Largeur de la bordure
                        ),
                        borderRadius:
                            BorderRadius.circular(20.0), // Rayon de la bordure
                      ),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                          color: _isPhysicalSelected
                              ? Colors.white
                              : Colors.blue[900]),
                      selectedColor: Colors.blue,
                      label: Text('Physique'),
                      selected: _isPhysicalSelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _isPhysicalSelected = isSelected;

                          _isCognitiveSelected = false;
                          _isOtherSelected = false;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FilterChip(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: _isCognitiveSelected
                              ? Colors.white
                              : Colors.blue[900] ??
                                  Colors.blue, // Couleur de la bordure
                          width: 1.0, // Largeur de la bordure
                        ),
                        borderRadius:
                            BorderRadius.circular(20.0), // Rayon de la bordure
                      ),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                          color: _isCognitiveSelected
                              ? Colors.white
                              : Colors.blue[900]),
                      selectedColor: Colors.blue,
                      label: Text('Cognitif'),
                      selected: _isCognitiveSelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _isCognitiveSelected = isSelected;
                          _isPhysicalSelected = false;

                          _isOtherSelected = false;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FilterChip(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: _isOtherSelected
                              ? Colors.white
                              : Colors.blue[900] ??
                                  Colors.blue, // Couleur de la bordure
                          width: 1.0, // Largeur de la bordure
                        ),
                        borderRadius:
                            BorderRadius.circular(20.0), // Rayon de la bordure
                      ),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                          color: _isOtherSelected
                              ? Colors.white
                              : Colors.blue[900]),
                      selectedColor: Colors.blue,
                      label: Text('Parole'),
                      selected: _isOtherSelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _isOtherSelected = isSelected;
                          _isPhysicalSelected = false;
                          _isCognitiveSelected = false;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Ajoutez d'autres chips pour d'autres filtres si nécessaire
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Espace entre les chips et le contenu filtré
            Visibility(
                visible: _isPhysicalSelected,
                child:
                    Container(height: 400, width: 500, child: ConsulterProg())),
            Visibility(
                visible: _isCognitiveSelected,
                child: Container(
                    height: 400, width: 500, child: ConsulterProgCog())),
            Visibility(
                visible: _isOtherSelected,
                child: Container(
                    height: 400, width: 500, child: ConsulterProgParole())),
            // Ajoutez d'autres widgets Visibility pour d'autres filtres si nécessaire
          ],
        ),
      ),
    );
  }
}
