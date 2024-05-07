import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageWidget extends StatelessWidget {
  final String conversation;

  const LastMessageWidget({Key? key, required this.conversation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('message')
          .where('id conver ', isEqualTo: conversation)
          .orderBy('Date', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Afficher un indicateur de chargement pendant le chargement des données.
        }

        if (snapshot.hasError) {
          return Text('Une erreur s\'est produite : ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Aucun message trouvé.');
        }

        // Récupérer le dernier message
        var lastMessage = snapshot.data?.docs.first;
        String messageText = lastMessage?[
            'contenu']; // Supposons que 'message' est le champ contenant le texte du message.

        String heure = lastMessage?['heure'];
        String heureMinute = heure.split(':').sublist(0, 2).join(':');
        return Container(
          width: 300,
          child: Row(children: [
            Text(
              messageText,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            Spacer(),
            Text(
              heureMinute,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.indigo,
                fontSize: 15,
              ),
            ),
            SizedBox(
              width: 5,
            )
          ]),
        );
      },
    );
  }
}
