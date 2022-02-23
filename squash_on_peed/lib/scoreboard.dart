import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:squash_on_peed/menu.dart';

import 'game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter/material.dart';

class scoreboard extends StatefulWidget {
  int score;
  int highscore;

  scoreboard({required this.score, required this.key, required this.highscore})
      : super(key: key);
  final GlobalKey<scoreboardState> key;

  @override
  scoreboardState createState() => scoreboardState();
}

class scoreboardState extends State<scoreboard> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/BG FOR MENU.png'),
                fit: BoxFit.fill)),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment(
                    (MediaQuery.of(context).size.width / -6.6) /
                        MediaQuery.of(context).size.width,
                    (MediaQuery.of(context).size.height / -2.7) /
                        MediaQuery.of(context).size.height),
                child: Container(
                    child: GradientText(
                  'SCORE: ' + widget.score.toString(),
                  gradientType: GradientType.linear,
                  style: TextStyle(
                      fontSize: 76,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(169, 169, 169, 1)
                  ],
                ))),
            Align(
                alignment: Alignment(
                    (MediaQuery.of(context).size.width / -25.6) /
                        MediaQuery.of(context).size.width,
                    (MediaQuery.of(context).size.height / 15.7) /
                        MediaQuery.of(context).size.height),
                child: Container(
                    child: GradientText(
                  'BEST SCORE: ' + widget.highscore.toString(),
                  gradientType: GradientType.linear,
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(169, 169, 169, 1)
                  ],
                ))),
            Align(
              alignment: Alignment(
                  (MediaQuery.of(context).size.width / -28.5) /
                      MediaQuery.of(context).size.width,
                  (MediaQuery.of(context).size.height / 2.45) /
                      MediaQuery.of(context).size.height),
              child: GestureDetector(
                child: Container(
                  child: Image.asset(
                    'assets/images/mainmenu.png',
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => menu()));
                },
              ),
            ),
            Align(
              alignment: Alignment(
                  (MediaQuery.of(context).size.width / -28.5) /
                      MediaQuery.of(context).size.width,
                  (MediaQuery.of(context).size.height / 2.75) /
                      MediaQuery.of(context).size.height),
              child: GestureDetector(
                child: Container(
                    child: Text(
                  'MAIN MENU',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => menu()));
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
