import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:squash_on_peed/game.dart';
import 'package:squash_on_peed/settings.dart';
import 'dart:async';
import 'main.dart';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class menu extends StatefulWidget {
  const menu({Key? key}) : super(key: key);

  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> {
  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
  }

  void dispose() {
    super.dispose();
    FlameAudio.bgm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlameAudio.bgm.play('Menu-sound.mp3');
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/BG FOR MENU.png'),
        fit: BoxFit.cover,
      )),
      child: Stack(
        children: <Widget>[
          Align(
            child: GestureDetector(
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 520, 300),
                  width: 58,
                  height: 42,
                  child: Image.asset('assets/images/setting con.png')),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => setting()));
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 1) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 0.5) /
                    MediaQuery.of(context).size.height),
            child: Container(
              height: 309.26,
              child: Image.asset(
                'assets/images/asfe 3.png',
              ),
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 1.45) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 0.68) /
                    MediaQuery.of(context).size.height),
            child: Container(
              height: 309.26,
              child: Image.asset(
                'assets/images/asfe 2.png',
              ),
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 1.9) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 0.91) /
                    MediaQuery.of(context).size.height),
            child: Container(
              height: 269.16,
              child: Image.asset(
                'assets/images/asfe 1.png',
              ),
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 2) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 2) /
                    MediaQuery.of(context).size.height),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 60),
              child: Image.asset(
                'assets/images/ball 1.png',
                height: 340.26,
              ),
            ),
          ),
          Align(
            alignment: Alignment(
                0,
                (MediaQuery.of(context).size.height / 2.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => game()));
              },
              child: Container(
                height: 83,
                width: 226,
                child: Image.asset(
                  'assets/images/START.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
