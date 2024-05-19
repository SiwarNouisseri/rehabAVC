import 'package:first/orthophoniste/drawerOrth.dart';
import 'package:first/orthophoniste/rendezVousDesPatient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RendezOrtho extends StatefulWidget {
  const RendezOrtho({super.key});

  @override
  State<RendezOrtho> createState() => _RendezOrthoState();
}

class _RendezOrthoState extends State<RendezOrtho> {
  @override
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        drawer: MyDrawerOrtho(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                height: 120,
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
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 300.0, top: 5),
                        child: GestureDetector(
                          onTap: () {
                            scaffoldkey.currentState!.openDrawer();
                          },
                          child: Icon(
                            CupertinoIcons.list_dash,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          "Mes Rendez-vous",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 23),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: RendezVpuschez()),
            ],
          ),
        ));
  }
}
