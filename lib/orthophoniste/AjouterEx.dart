import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first/components/description.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';

class AjouterEx extends StatefulWidget {
  const AjouterEx({Key? key}) : super(key: key);

  @override
  State<AjouterEx> createState() => _AjouterExState();
}

class _AjouterExState extends State<AjouterEx> {
  void showVideoNotPickedPopup(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Erreur',
      desc: 'Veuillez télécharger une vidéo.',
    ).show();
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isUploading = false;
  bool picked = false;
  bool showDeleteButton = false;
  bool showChangeButton = false;
  bool showTerminateButton = false;

  final exercisesCollection =
      FirebaseFirestore.instance.collection("exercices");
  late VideoPlayerController _videoPlayerController;
  File? _video;
  String? videoUrl;
  static String? url;
  static int? uploadProgress;
  static UploadTask? _currentUploadTask;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network('');
    uploadProgress == 0;
    // videoUrlFuture = getimageUrl();
  }

  Future<void> pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      _video = File(video.path);

      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _videoPlayerController.play();
              showDeleteButton = true;
              showChangeButton = true;
            });
          }
        });

      // Upload the video to Firebase Cloud Storage
      await uploadVideo(_video!);
    }
  }

  // Method to upload video to Firebase Cloud Storage
  Future<void> uploadVideo(File videoFile) async {
    try {
      setState(() {
        isUploading = true;
      });
      // Create a unique file name for the video
      String videoFileName =
          DateTime.now().millisecondsSinceEpoch.toString() + ".mp4";
      // Reference to Firebase Storage bucket
      Reference reference =
          FirebaseStorage.instance.ref().child("videos/$videoFileName");

      // Start the upload
      UploadTask uploadTask = reference.putFile(videoFile);

      //  the uploadTask to monitor upload progress, manage pausing and resuming, etc.
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Calculate the upload progress
        double progress =
            snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
        setState(() {
          uploadProgress = (progress * 100).toInt();
          _currentUploadTask = uploadTask;
        });

        // update a progress bar or display the progress in another way
        print("Upload progress: ${(progress * 100).toStringAsFixed(2)}%");
      });
      await uploadTask;

      //  download URL after uploading
      final videoUrl = await reference.getDownloadURL();
      url = videoUrl;
      print("++++++++++++++++++++++++++++++Video uploaded: $videoUrl");
    } catch (e) {
      print("Error uploading video: $e");
    }
  }

  Future<void> cancelUpload() async {
    if (isUploading && _currentUploadTask != null) {
      try {
        // Pause the upload task first
        await _currentUploadTask!.pause();
        print("Video upload paused.");

        // Cancel the upload task
        await _currentUploadTask!.cancel();
        print("Video upload cancelled.");
      } catch (e) {
        if (e is FirebaseException) {
          print("Upload cancelled by user: ${e.message}");
          // Or handle the error differently
        } else {
          print("Unexpected error cancelling upload: $e");
          // Handle other potential errors
        }
      } finally {
        setState(() {
          isUploading = false;
          uploadProgress = null;
          showDeleteButton = false;
          showChangeButton = false;
          _video = null;
          _videoPlayerController = VideoPlayerController.network('');
        });
      }
    }
  }

  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
    nom.dispose();
    type.dispose();
  }

  void addVideoDetails(String name, String description, String type) async {
    await FirebaseFirestore.instance.collection('exercices').add({
      'nom': name,
      'description': description,
      'type': type,
      'Date ajout': DateTime.now(),
      'id de docteur': FirebaseAuth.instance.currentUser?.uid,
      'urlvideo': url,
    });
  }

  TextEditingController nom = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController description = TextEditingController();
  var selectedType = "Physique";
  @override
  Widget build(BuildContext context) {
    if (isUploading) {
      setState(() {
        uploadProgress =
            uploadProgress; // Calculate the actual progress value here
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: formState,
        child: ListView(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[400] ?? Colors.blue,
                    Colors.blue[200] ?? Colors.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
                color: Colors.blue[300],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "Ajouter des exercices",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 24),
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Container(
                    width: 100, child: Image.asset("images/add-video.png")),
              ],
            ),
            Custom(
              validator: (val) {
                if (val == "") {
                  return " champs vide ";
                }
              },
              hinttext: "Nom d'exercice",
              mycontroller: nom,
            ),

            Row(
              children: [
                SizedBox(width: 30),
                Text(
                  "Type :",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue[700]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(
                          color: Colors.blue), // Couleur de la bordure
                      borderRadius:
                          BorderRadius.circular(10), // Rayon de la bordure
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: DropdownButton(
                        dropdownColor: Colors.blue,
                        iconEnabledColor: Colors.red,
                        items: ["Cognitif", "Physique", "Parole"]
                            .map((e) => DropdownMenuItem(
                                  child: Text("$e"),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedType = val!;
                          });
                        },
                        value: selectedType,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                validator: (val) {
                  if (val == "") {
                    return " champs vide ";
                  }
                },
                controller: description,
                maxLines: 5,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        color: Colors.blue[500] ?? Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        color: Colors.blue[500] ?? Colors.blue, width: 1.5),
                  ),
                  labelText: "Description d'exercice",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_video != null &&
                      _videoPlayerController.value.isInitialized)
                    Column(
                      children: [
                        Stack(alignment: Alignment.center, children: [
                          AspectRatio(
                            aspectRatio: 16 / 4,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                          IconButton(
                            icon: _videoPlayerController.value.isPlaying
                                ? const Icon(Icons.pause,
                                    size: 50, color: Colors.white)
                                : const Icon(Icons.play_arrow,
                                    size: 50, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                if (_videoPlayerController.value.isPlaying) {
                                  _videoPlayerController.pause();
                                } else {
                                  _videoPlayerController.play();
                                }
                              });
                            },
                          ),
                        ]),
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Téléchargement en cours: ${(uploadProgress ?? 0)}%",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey[700]),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: LinearProgressIndicator(
                                value: uploadProgress != null
                                    ? uploadProgress! / 100
                                    : null,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue[200] ?? Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else if (picked == false)
                    Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(
                        onTap: () {
                          pickVideo();
                          setState(() {
                            picked == true;
                          });
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Image.asset("images/download.png", width: 50),
                            Text(
                              "Télécharger ici ",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: " PlaypenSans",
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showDeleteButton && _video != null)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                cancelUpload();
                              },
                              child: Container(
                                width: 30,
                                child: Image.asset('images/delete.png'),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(width: 10),
                      /* if (showChangeButton)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  //_videoPlayerController.pause();
                                  cancelUpload();
                                  pickVideo();
                                });
                              },
                              child: Container(
                                width: 30,
                                child: Image.asset('images/transfer.png'),
                              ),
                            ),
                          ],
                        )*/
                    ],
                  ),
                ],
              ),
            ),
            //     if (uploadProgress == 100)
            Column(
              children: [
                Container(
                  width: 180,
                  child: MaterialButton(
                    minWidth: 60,
                    height: 40,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        if (_video == null) {
                          showVideoNotPickedPopup(context);
                        } else {
                          try {
                            // Ajouter les détails de la vidéo après le téléchargement
                            addVideoDetails(
                                nom.text, description.text, selectedType);

                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Succès',
                                    desc: 'Exercice ajouté avec succès')
                                .show();

                            setState(() {
                              nom.clear();
                              description.clear();
                              _video = null;
                            });
                            //_video = null;

                            /* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AjouterEx()),
                            );*/
                          } catch (e) {
                            print('Error adding video details: $e');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Erreur',
                              desc:
                                  'Une erreur s\'est produite lors de l\'ajout de l\'exercice.',
                            ).show();
                          }
                        }
                      }
                      ;
                    },
                    child: Text(
                      "Terminer",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
