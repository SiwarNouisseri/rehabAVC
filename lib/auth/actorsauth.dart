import 'package:first/auth/signup.dart';
import 'package:flutter/material.dart';

class Actor extends StatelessWidget {
  const Actor({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        ListView(
          children: [
            Container(
              height: 70,
            ),
            Center(
              child: Text("Connectez vous en tant que",
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w900,
                      fontSize: 26)),
            ),
            Container(
              height: 50,
            ),
            Image.asset("images/welcome.png", height: 250, width: 10),
            Container(
              height: 100,
            ),
            Column(
              children: [
                Container(
                  width: 390,
                  child: MaterialButton(
                    height: 70,
                    minWidth: 100,
                    color: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("signupOrth");
                    },
                    child: Text("Spécialiste",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20)),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
            ),
            Column(
              children: [
                Container(
                  width: 390,
                  child: MaterialButton(
                    color: Colors.blue[400],
                    height: 70,
                    minWidth: 50,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("signup");
                    },
                    child: Text("Patient",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
