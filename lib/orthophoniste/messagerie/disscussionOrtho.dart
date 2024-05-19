import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DisscussionOrtho extends StatefulWidget {
  final String id;

  const DisscussionOrtho({Key? key, required this.id}) : super(key: key);

  @override
  State<DisscussionOrtho> createState() => _DisscussionOrthoState();
}

class _DisscussionOrthoState extends State<DisscussionOrtho> {
  bool isYouTheSender(String senderId) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return currentUserId != null && currentUserId == senderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('message')
            .where('id conver ', isEqualTo: widget.id)
            .orderBy('Date', descending: false)
            .orderBy('__name__', descending: false)
            .snapshots(), // Corrected 'id conver' to 'id_conver'

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.docs.isEmpty) {
              return Container();
            } else {
              Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

              // Group messages by date
              snapshot.data!.docs.forEach((document) {
                final date =
                    DateFormat.yMMMd().format(document.get('Date').toDate());
                groupedMessages.putIfAbsent(date, () => []).add(document);
                List<String> sortedDates = groupedMessages.keys.toList();
                sortedDates.sort((a, b) => DateFormat.yMMMd()
                    .parse(b)
                    .compareTo(DateFormat.yMMMd().parse(a)));
              });

              return ListView.builder(
                itemCount: groupedMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  final date = groupedMessages.keys.elementAt(index);
                  final messages = groupedMessages[date]!;

                  // Create a list of BubbleNormal widgets for messages in the same date group
                  List<Widget> bubbleWidgets = messages.map((msgDocument) {
                    final contenu = msgDocument.get('contenu');
                    final envoyeur = msgDocument.get('envoyeur');
                    final recepteur = msgDocument.get('recepteur');
                    final heure = msgDocument.get('heure');
                    final status = msgDocument.get('statut');
                    final docid = msgDocument.id;
                    print("++++++++++++++++++$index $status");
                    String heureMinute =
                        heure.split(':').sublist(0, 2).join(':');
                    bool isSender = isYouTheSender(envoyeur);

                    return Column(
                      children: [
                        CustomMessageBubble(
                          text: contenu,
                          isSender: isSender,
                          time: heureMinute,
                          docid: docid,
                          status: status,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  }).toList();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          date,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[300]),
                        ),
                      ),
                      ...bubbleWidgets,
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
