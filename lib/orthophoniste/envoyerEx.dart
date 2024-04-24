import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:first/components/displayVideoDoc.dart';
import 'package:first/components/exerciceContainer.dart';
import 'package:first/components/try.dart';
import 'package:first/orthophoniste/homertho.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EnvoyerOrtho extends StatefulWidget {
  const EnvoyerOrtho({super.key});

  @override
  State<EnvoyerOrtho> createState() => _EnvoyerOrthoState();
}

class _EnvoyerOrthoState extends State<EnvoyerOrtho> {
  late CachedVideoPlayerController
      videoPlayerController; // Change to CachedVideoPlayerController
  late CustomVideoPlayerController _customVideoPlayerController;

  String videoUrl =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(
        videoUrl) // Change to CachedVideoPlayerController.network
      ..initialize().then((_) {
        setState(() {});
      });
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          height: 100,
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
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3), // Couleur de l'ombre
                spreadRadius: 3, // Rayon de diffusion de l'ombre
                blurRadius: 8, // Rayon de flou de l'ombre
                offset: Offset(0, 3), // Décalage de l'ombre
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 30.0),
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeOrtho()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      Container(
                        width: 10,
                      ),
                      Text(
                        "Envoyer des exercices",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        /*  CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController),*/
        Container(height: 700, child: Try())
      ],
    ));
  }
}
