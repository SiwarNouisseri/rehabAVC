import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/patient/drawer.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Colors.blue[300] ?? Colors.blue,
        animationCurve: Curves.linear,
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue[200] ?? Colors.blue,
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          Icon(
            Icons.message,
            color: Colors.white,
          ),
        ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
        title: Text(
          'Admin  ',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        titleSpacing: 10,
        actions: const [
          // Insérez ici votre image d'utilisateur
          Padding(
            padding: EdgeInsets.only(right: 20, top: 5),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage("images/avatar.jpeg"),
            ),
          ),
        ],
      ),
      //   drawer: MyDrawer(),
    );
  }
}
