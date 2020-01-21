import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'login.dart';
import 'dart:io';
import 'package:page_transition/page_transition.dart';

void main() {
  Function duringSplash = () {
    return 1;
  };

  Map<int, Widget> op = {1: MyApp()};

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplash(
        imagePath: 'assets/logo2.png',
        home: login(),
        customFunction: duringSplash,
        duration: 3500,
        type: AnimatedSplashType.BackgroundProcess,
        outputAndHome: op,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(    //prevent back button accidental touch, has exit app option
      onWillPop: () => showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        shape: RoundedRectangleBorder( //give dialogbox rounded corners
            borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
        content: Text('Do you really want to exit?'),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () => exit(0), //terminate app
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    ),
    child: MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: Column(children: <Widget>[
      Container(
          width: 259,
          height: 171,
          margin: EdgeInsets.only(top: 145),
          child: Image.asset(
            "assets/Logo.png",
            fit: BoxFit.cover,
          )),
      GestureDetector( //to detect touch on top of image
          onTap: () {
            Navigator.push(context, PageTransition(type: PageTransitionType.downToUp, child:login()) );
          },
          child: Container(
              width: 200,
              height: 100,
              margin: EdgeInsets.only(top: 50),
              child: Stack(alignment: Alignment.center, children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/Start_btn.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ]))),
  ]))))));
  }
}
