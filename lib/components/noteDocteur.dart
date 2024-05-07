import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  final String notee;
  final DateTime dateStatic;
  const Note({super.key, required this.notee, required this.dateStatic});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 85.0, right: 85),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text(
                            "Note de docteur:",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Container(
                            height: 30,
                            width: 40,
                            child: Image.asset("images/pin (1).png"))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.notee,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                  height: 50,
                  width: 40,
                  child: Image.asset("images/deadline (1).png")),
              Text(
                "Date limite :" +
                    "${widget.dateStatic?.day} /" +
                    "${widget.dateStatic?.month} /" +
                    "${widget.dateStatic?.year}",
                style: TextStyle(
                  color: Colors.blueGrey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
