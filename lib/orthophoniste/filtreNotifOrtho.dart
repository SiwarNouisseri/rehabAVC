import 'package:first/components/notifContainer.dart';
import 'package:first/patient/NotifMess.dart';
import 'package:flutter/material.dart';

class FiltreOrtho extends StatefulWidget {
  const FiltreOrtho({super.key});

  @override
  State<FiltreOrtho> createState() => _FiltreOrthoState();
}

class _FiltreOrthoState extends State<FiltreOrtho> {
  bool _isCognitiveSelected = true;
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

          Visibility(visible: _isCognitiveSelected, child: Notif()),
          Visibility(visible: _isOtherSelected, child: NotifyMess()),
          // Ajoutez d'autres widgets Visibility pour d'autres filtres si nécessaire
        ],
      ),
    );
  }
}
