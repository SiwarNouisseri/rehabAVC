import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EditEx extends StatefulWidget {
  final String url;
  const EditEx({Key? key, required this.url}) : super(key: key);

  @override
  State<EditEx> createState() => _EditExState();
}

class _EditExState extends State<EditEx> {
  late VideoPlayerController videoPlayerController;
  late ChewieController? chewieController;
  bool isVideoInitialized = false;
  bool isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.url);

    await videoPlayerController.initialize();

    setState(() {
      isVideoLoading = false;
    });

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Couleur de l'icône de retour
        ),
        backgroundColor: Colors.blue[400],
        title: const Text(
          "Consulter vidéo",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 23),
        ),
        titleSpacing: 50,
        elevation: 7,
      ),
      body: isVideoLoading
          ? const Center(
              child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Text(
                    "Votre vidéo est en train de charger \n attendez un peu s'il vous plaît.",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(
                  height: 100,
                ),
                CircularProgressIndicator(color: Colors.blue),
              ],
            ))
          : chewieController != null
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Chewie(controller: chewieController!))
              : Center(
                  child: Text("Erreur de chargement de la vidéo."),
                ),
    );
  }
}
