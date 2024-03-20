import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditMe extends StatefulWidget {
  final IconData icon;
  final String title;
  final void Function()? tap;
  EditMe({
    super.key,
    required this.icon,
    required this.title, this.tap,
    /*required this.number*/
  });

  @override
  State<EditMe> createState() => _EditMeState();
}

class _EditMeState extends State<EditMe> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 20),
            Icon(widget.icon, color: Colors.blue),
            SizedBox(width: 40),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 17,
              ),
            ),
            Spacer(),
            SizedBox(width: 20),
            //SizedBox(width: widget.number),
            GestureDetector(
              onTap: tap
              child: Image.asset(
                "images/final.png",
                width: 20,
              ),
            ),
            /* SizedBox(width: 5),
            Image.asset(
              "images/tick-mark.png",
              width: 20,
            ),*/
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
