import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';

class CustomMessageBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String time;
  final String docid;

  const CustomMessageBubble({
    Key? key,
    required this.text,
    required this.isSender,
    required this.time,
    required this.docid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.question,
          animType: AnimType.bottomSlide,
          title: 'Vous êtes sûr de supprimer ce message ',
          btnOkOnPress: () async {
            await FirebaseFirestore.instance
                .collection('message')
                .doc(docid)
                .delete();
          },
        ).show();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isSender ? Color(0xFFE8E8EE) : Color(0xFF1B97F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSender ? Colors.black : Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: 60,
                  child: Row(
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSender ? Colors.grey : Colors.white70,
                        ),
                      ),
                      SizedBox(width: 4),
                      Image.asset(
                        'images/double-check.png',
                        width: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
