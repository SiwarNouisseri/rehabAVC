import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageWidget extends StatelessWidget {
  bool isYouTheSender(String senderId) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return currentUserId != null && currentUserId == senderId;
  }

  bool getStatusBool(String status) {
    if (status == 'vu') {
      return true;
    } else {
      return false;
    }
  }

  Widget buildMessageText(String status, bool isSender, String textContent) {
    if (isSender) {
      return Text(
        "Vous : $textContent",
        style: TextStyle(fontWeight: FontWeight.w300),
      );
    } else {
      return Text(
        textContent,
        style: status == "vu"
            ? TextStyle(fontWeight: FontWeight.w300)
            : TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

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

        var lastMessage = snapshot.data?.docs.first;
        String messageText = lastMessage?['contenu'];
        String status = lastMessage?['statut'];
        String heure = lastMessage?['heure'];
        String envoyeur = lastMessage?['envoyeur'];
        String heureMinute = heure.split(':').sublist(0, 2).join(':');
        bool isSender = isYouTheSender(envoyeur);
        bool isSeen = getStatusBool(status);
        return Container(
          width: 300,
          child: Row(children: [
            buildMessageText(status, isSender, messageText),
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
