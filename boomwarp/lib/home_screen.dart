import 'dart:async';
import 'dart:io';
import 'package:boomwarp/screens/homepage.dart';
import 'package:boomwarp/screens/songs.dart';
import 'package:boomwarp/screens/setting.dart';
import 'package:boomwarp/screens/video.dart';
import 'package:boomwarp/searchpage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  final screens = [
    Homepage(),
    songs(),
    video(),
    setting(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.home,
        size: 30,
        color: Colors.white70,
      ),
      Icon(
        Icons.music_note,
        size: 30,
        color: Colors.white70,
      ),
      Icon(
        Icons.videocam,
        size: 30,
        color: Colors.white70,
      ),
      const Icon(
        Icons.settings,
        size: 30,
        color: Colors.white70,
      ),
    ];

    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: screens[index],
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          height: 60,
          color: Colors.grey.shade900,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.indigo.shade300,
          onTap: (index) => setState(() => this.index = index),
          animationDuration: Duration(milliseconds: 200),
          animationCurve: Curves.bounceInOut,
          index: index,
          items: items,
        ));
  }
}
