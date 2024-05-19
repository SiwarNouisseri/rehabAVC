import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class Dossier extends StatefulWidget {
  const Dossier({super.key});

  @override
  State<Dossier> createState() => _DossierState();
}

class _DossierState extends State<Dossier> {
  bool _isLoading = false;
  TextEditingController ageController = TextEditingController();
  TextEditingController medicationsController = TextEditingController();

  TextEditingController rehabSummaryController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  static String name = "";
  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }

  String extractFileName(String filePath) {
    List<String> pathSegments = filePath.split('/');
    return pathSegments.isNotEmpty ? pathSegments.last : '';
  }

  Future<void> choosePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      // Traiter le fichier choisi (par exemple, l'enregistrer dans le cloud)
      uploadPDFToCloud(context, file);
    } else {
      return;
    }
  }

  double _uploadProgress = 0.0;

  Future<void> uploadPDFToCloud(BuildContext context, PlatformFile file) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child('pdf').child(file.name);
    UploadTask uploadTask = storageRef.putFile(File(file.path!));

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _uploadProgress =
            (snapshot.bytesTransferred / snapshot.totalBytes).clamp(0.0, 1.0);
        name = file.path!;
      });
    });

    try {
      await uploadTask;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Fichier PDF enregistré dans le Cloud Storage.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Erreur lors de l\'enregistrement du fichier PDF : $error')),
      );
    }
  }

  String getCheckedText() {
    if (_isCheckedList[0]) {
      return 'Oui';
    } else if (_isCheckedList[1]) {
      return 'Non';
    } else {
      return ''; // Retourner une chaîne vide ou une autre valeur par défaut si aucun n'est coché
    }
  }

  bool _uploading = false;
  double _progress = 0.0;

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _uploading = true;
        _progress = 0.0;
      });

      File file = File(result.files.single.path!);
      String fileName = path.basename(result.files.single.name);
      print('++++++++++++++++++Selected PDF file name: $fileName');
      setState(() {
        name = fileName;
      });
      Reference storageRef =
          FirebaseStorage.instance.ref().child('pdfs').child(fileName);

      UploadTask uploadTask = storageRef.putFile(
        file,
        // Définir la fonction de suivi de progression
        SettableMetadata(
          customMetadata: {
            'uploaded_by': 'user_id'
          }, // Métadonnées personnalisées si nécessaire
        ),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _progress = (snapshot.bytesTransferred / snapshot.totalBytes);
        });
      });

      await uploadTask.whenComplete(() async {
        String downloadURL = await storageRef.getDownloadURL();
        urlPdf = downloadURL;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fichier PDF enregistré avec succès',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  static String urlPdf = "";
  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  List<bool> _isCheckedList = [false, false];
  var selectedType = "ischémique";
  int _selectedValue = 0;
  String selectedValue = '';
  int _selectedAge = 18;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
        title: Text(
          ' Dossier médical',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        titleSpacing: 50,
      ),
      body: ListView(children: [
        Container(
          height: 30,
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
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
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
        ),
        SizedBox(height: 30),
        Container(height: 100, child: Image.asset("images/clipboard.png")),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Age :",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey,
                          fontSize: 18)),
                  SizedBox(
                    width: 74,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 55, right: 9),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        width: 159,
                        child: Center(
                          child: DropdownButton<int>(
                            iconEnabledColor: Colors.red,
                            value: _selectedAge,
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedAge = newValue!;
                              });
                            },
                            items: List.generate(
                              90, // Generate items for ages 18 to 100
                              (index) => DropdownMenuItem<int>(
                                value: 16 + index, // Start from 18
                                child: Text('${16 + index} ans'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Text("Date de l\'AVC :",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.blueGrey,
                        fontSize: 18)),
                SizedBox(width: 2),
                Column(
                  children: [
                    Container(
                      width: 220,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Padding(
                          padding: EdgeInsets.only(left: 48, right: 15),
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              hintText: 'date',
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.blue[50],
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.red,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              selectDate();
                            },
                          )),
                    ),
                  ],
                ),
              ]),
              Row(
                children: [
                  Text('Type d\'AVC :',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey,
                          fontSize: 18)),
                  SizedBox(
                    width: 65,
                  ),
                  Card(
                    child: Container(
                      width: 158,
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: DropdownButton(
                          // dropdownColor: Colors.blue,
                          iconEnabledColor: Colors.red,
                          items: ["hémorragique", "ischémique"]
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
              SizedBox(height: 30.0),
              Text('Avez-vous déjà suivi des séances de rééducation en ligne ?',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 40, 105, 202),
                      fontSize: 14.9)),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        value: _isCheckedList[0],
                        onChanged: (value) {
                          setState(() {
                            _isCheckedList[0] = value!;
                          });
                        },
                      ),
                      Text('Oui',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 17)),
                    ],
                  ),
                  SizedBox(width: 40), // Adjust spacing between checkboxes
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.red,
                        value: _isCheckedList[1],
                        onChanged: (value) {
                          setState(() {
                            _isCheckedList[1] = value!;
                          });
                        },
                      ),
                      Text('Non',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 17)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Text('Déposer votre ancien dossier médical ici en format PDF',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 40, 105, 202),
                      fontSize: 14)),
              SizedBox(height: 10.0),
              Center(
                child: _uploading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 40,
                              width: 70,
                              child: Image.asset('images/pdf.png')),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: LinearProgressIndicator(
                                value: _progress, color: Colors.red),
                          ),
                          SizedBox(height: 5),
                          Text('${(_progress * 100).toStringAsFixed(0)} %'),
                        ],
                      )
                    : GestureDetector(
                        onTap: () async {
                          /*final result = await FilePicker.platform
                        .pickFiles(allowedExtensions: ['pdf']);
                    if (result == null) {
                      return;
                    }
                    //final file = result.files.first;
                    //openFile(file);*/
                          _uploadFile();
                        },
                        child: Container(
                            height: 40,
                            width: 70,
                            child: Image.asset('images/file2.png')),
                      ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: 150,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular((90))),
                        color: const Color.fromARGB(255, 236, 84, 81),
                        onPressed: () async {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: ' Déposition de dossier ',
                                  desc:
                                      'Vous êtes sûr de déposer votre dossier ?',
                                  btnCancelOnPress: () {},
                                  btnCancelText: "Non",
                                  btnOkOnPress: () async {
                                    DateTime date =
                                        DateTime.parse(_dateController.text);
                                    await FirebaseFirestore.instance
                                        .collection('dossier')
                                        .add({
                                      'age': _selectedAge,
                                      'date Avc': date,
                                      'type Avc': selectedType,
                                      'rééduction enligne': getCheckedText(),
                                      'url pdf': "pdfs/" + name,
                                      'id patient': FirebaseAuth
                                          .instance.currentUser!.uid,
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Dossier()),
                                    );
                                  },
                                  btnOkText: "Oui")
                              .show();
                        },
                        child: Text('Enregistrer',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
