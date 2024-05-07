import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/orthophoniste/messagerie/disscussionOrtho.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

// Classe pour représenter un message
TextEditingController controller = TextEditingController();

class Messagerie extends StatefulWidget {
  final String patient;
  final String image;
  final String idConver;
  final String idPatient;
  const Messagerie(
      {Key? key,
      required this.patient,
      required this.image,
      required this.idConver,
      required this.idPatient})
      : super(key: key);

  @override
  State<Messagerie> createState() => _MessagerieState();
}

class _MessagerieState extends State<Messagerie> {
  Future<void> addmessDetails(String contenu) async {
    try {
      DateTime now = DateTime.now();
      String dateNow =
          '${now.day}-${now.month}-${now.year}'; // Format: YYYY-MM-DD
      String timeNow = '${now.hour}:${now.minute}:${now.second}';
      await FirebaseFirestore.instance.collection('message').add({
        'id conver ': widget.idConver,
        'contenu': contenu,
        'Date': DateTime.now(),
        'heure': timeNow,
        'envoyeur': FirebaseAuth.instance.currentUser!.uid,
        'recepteur': widget.idPatient
      });
    } catch (e) {
      print('Error adding conversation details: $e');
      // Gérer l'erreur selon vos besoins
    }
  }

  // Liste de messages de test
  List<Message> messages = [];

  // Fonction pour grouper les messages par date
  List<List<Message>> groupMessagesByDate(List<Message> messages) {
    final groupedMessages =
        groupBy(messages, (Message message) => message.date);
    return groupedMessages.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 120,
            width: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[100] ?? Colors.blue,
                  Colors.blue[400] ?? Colors.blue,
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
                  spreadRadius: 5, // Rayon de diffusion de l'ombre
                  blurRadius: 8, // Rayon de flou de l'ombre
                  offset: Offset(0, 3), // Décalage de l'ombre
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    widget.patient,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 23),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(child: DisscussionOrtho(id: widget.idConver)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Espacement entre les éléments
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.grey[300] ?? Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintText: "écrire votre message ici",
                        border: InputBorder.none, // Pas de bordure visible
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espacement entre l'Input et l'IconButton
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    // Bordures rondes
                    color: Colors.blue, // Fond bleu
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final message = Message(
                        date: DateTime.now(),
                        text: controller.text,
                        isSentByMe: true,
                      );
                      await addmessDetails(controller.text);

                      setState(() => messages.add(message));

                      controller.clear();
                    },
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

//classe de message : pour construire la forme de objet message
class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

//classe de bubble de message : UI design ici et comment elle va etre afficher selon le sender et le receiver
class CustomBubbleNormal extends StatelessWidget {
  final String text;
  final bool isSender;
  final Color color;
  final bool tail;
  final TextStyle textStyle;

  const CustomBubbleNormal({
    required this.text,
    required this.isSender,
    required this.color,
    required this.tail,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isSender ? Colors.black : Colors.white;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 12 : 0),
            topRight: Radius.circular(isSender ? 0 : 12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: textStyle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
