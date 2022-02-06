import 'dart:async';
import 'dart:io';
import 'package:boomwarp/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 6),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/ic_launcher.png',
                height: 350,
                width: 350,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 120.0),
            child: Text(
              "Xenon",
              style: TextStyle(
                color: Color(0xFFBB86FC),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]));
  }
}
