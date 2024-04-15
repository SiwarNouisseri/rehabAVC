import 'package:first/components/videoplayer.dart';
import 'package:flutter/material.dart';

class MessOrtho extends StatefulWidget {
  const MessOrtho({super.key});

  @override
  State<MessOrtho> createState() => _MessOrthoState();
}

class _MessOrthoState extends State<MessOrtho> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VideoPlayerPage(
      url:
          "https://firebasestorage.googleapis.com/v0/b/first-f2149.appspot.com/o/videos%2F1712521225437.mp4?alt=media&token=7ccd0dd3-dddf-431e-b0e9-22e17813657f",
    ));
  }
}
