import 'package:first/patient/NotifMess.dart';
import 'package:first/patient/notifContPatient.dart';
import 'package:first/patient/notifExer.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool _isPhysicalSelected = true;
  bool _isCognitiveSelected = false;
  bool _isOtherSelected = false; // Nouveau état pour le troisième chip

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
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
                  label: Text('Exercices'),
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
                  label: Text('Suivie'),
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
                      color:
                          _isOtherSelected ? Colors.white : Colors.blue[900]),
                  selectedColor: Colors.blue,
                  label: Text('Messages'),
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
          SizedBox(height: 20), // Espace entre les chips et le contenu filtré
          Visibility(visible: _isPhysicalSelected, child: NotifEx()),
          Visibility(visible: _isCognitiveSelected, child: NotifyMe()),
          Visibility(visible: _isOtherSelected, child: NotifyMess()),
          // Ajoutez d'autres widgets Visibility pour d'autres filtres si nécessaire
        ],
      ),
    );
  }
}
