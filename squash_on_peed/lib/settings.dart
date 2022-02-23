import 'dart:ui';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_on_peed/menu.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  bool ifplaying = true;

  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
  }

  void dispose() {
    super.dispose();
    FlameAudio.bgm.dispose();
  }

  void changestatus() {
    setState(() {
      ifplaying = !ifplaying;
      print(ifplaying);
    });
    if (ifplaying) {
      FlameAudio.bgm.play('Menu-sound.mp3');
      Align(
          alignment: Alignment(
              (MediaQuery.of(context).size.width / -1.8) /
                  MediaQuery.of(context).size.width,
              (MediaQuery.of(context).size.height / 4.6) /
                  MediaQuery.of(context).size.height),
          child: GestureDetector(
            child: Container(
              child: Image.asset(
                'assets/images/loudspeaker_red.png',
              ),
            ),
            onTap: () {},
          ));
    } else {
      FlameAudio.bgm..pause();
      Align(
          alignment: Alignment(
              (MediaQuery.of(context).size.width / -1.8) /
                  MediaQuery.of(context).size.width,
              (MediaQuery.of(context).size.height / 4.6) /
                  MediaQuery.of(context).size.height),
          child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/loudspeaker_grey.png',
                ),
              ),
              onTap: () {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/BG FOR MENU.png'),
                    fit: BoxFit.fill)),
            child: Stack(children: <Widget>[
              Align(
                  alignment: Alignment(
                      (MediaQuery.of(context).size.width / -1.8) /
                          MediaQuery.of(context).size.width,
                      (MediaQuery.of(context).size.height / 4.6) /
                          MediaQuery.of(context).size.height),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      child: Image.asset(ifplaying
                          ? 'assets/images/loudspeaker_red.png'
                          : 'assets/images/loudspeaker_grey.png'),
                    ),
                    onTap: () {
                      print(ifplaying);
                      changestatus();
                    },
                  )),
              Align(
                  alignment: Alignment(
                      (MediaQuery.of(context).size.width / -100.8) /
                          MediaQuery.of(context).size.width,
                      (MediaQuery.of(context).size.height / 4.6) /
                          MediaQuery.of(context).size.height),
                  child: Container(
                    child: Image.asset(
                      'assets/images/vibration_grey.png',
                    ),
                  )),
            ])));
  }
}
