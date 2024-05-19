import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:first/auth/Role.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 400,
      child: AnimatedSplashScreen(
          duration: 3000,
          splash: Image.asset("images/splash.png"),
          splashIconSize: 150000,
          nextScreen: RoleChecker(),
          splashTransition: SplashTransition.fadeTransition,
          //pageTransitionType: PageTransitionType.scale,
          backgroundColor: Colors.blue[400] ?? Colors.blue),
    );
  }
}
