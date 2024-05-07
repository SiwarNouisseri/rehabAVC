import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class videoEx extends StatefulWidget {
  final String url;
  const videoEx({super.key, required this.url});

  @override
  State<videoEx> createState() => _videoExState();
}

class _videoExState extends State<videoEx> {
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
      body: isVideoLoading
          ? AspectRatio(
              aspectRatio: 3 / 2,
              child: const Center(
                  child: Column(
                children: [
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
              )),
            )
          : chewieController != null
              ? AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Chewie(controller: chewieController!)),
                )
              : Center(
                  child: Text("Erreur de chargement de la vidéo."),
                ),
    );
  }
}
