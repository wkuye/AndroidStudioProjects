import 'dart:typed_data';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:squash_on_peed/scoreboard.dart';
import 'dart:async';
import 'dart:math';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'scoreboard.dart';
import 'package:flutter/material.dart';

class game extends StatefulWidget {
  const game({Key? key}) : super(key: key);

  @override
  _gameState createState() => _gameState();
}

class _gameState extends State<game> {
  final GlobalKey<scoreboardState> key = GlobalKey<scoreboardState>();
  AudioPlayer player = AudioPlayer();
  void initState() {
    checkFirstSeen();
    super.initState();
  }

  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
    }
    player.dispose();
  }

  int rand = 0, health = 3, score = 0, singleShotKills = 0, highscore = 0;
  Timer? timer;

  void checkFirstSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highscore = prefs.getInt('highscore') ?? 0;
    });
  }

  void check() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('highscore', highscore);
    setState(() {
      if (score > highscore) {
        highscore = score;
        prefs.setInt('highscore', highscore);
      }
    });
  }

  bool launched = false, finishing = false, reviving = false;
  decreaseLife() {
    --health;
    reviving = true;

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        reviving = false;
      });
    });
  }

  endgame() {
    check();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => scoreboard(
                  score: score,
                  key: key,
                  highscore: highscore,
                )));
  }

  ball1() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -2.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball2() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -6.8) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                ;
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball3() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball4() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 2.7) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball5() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -2.6) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball6() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -6.8) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball7() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball8() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 2.7) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 5.0) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball9() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -2.7) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 1.55) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/5',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball10() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -6.85) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 1.55) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
                child: Container(
                    child: Text(
                  '3/2',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
                onTap: () {
                  FlameAudio.play('correct-answer.mp3');
                  score += 3;

                  randomize();
                }),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball11() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.7) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 1.55) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/5',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/2',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  ball12() {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 2.7) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / 1.55) /
                    MediaQuery.of(context).size.height),
            child: Container(child: Image.asset('assets/images/ball.png')),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.2) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -4.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.playLongAudio('Wrong answer.mp3', volume: 1);
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 7.5) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.7) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                child: Image.asset(
                  'assets/images/Rectangle.png',
                ),
              ),
              onTap: () async {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '2/6',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / -5.0) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '1/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.25) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/3',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.playLongAudio('Wrong answer.mp3');
                if (health > 0) {
                  decreaseLife();
                } else {
                  endgame();
                }
                randomize();
              },
            ),
          ),
          Align(
            alignment: Alignment(
                (MediaQuery.of(context).size.width / 8.3) /
                    MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.height / -1.75) /
                    MediaQuery.of(context).size.height),
            child: GestureDetector(
              child: Container(
                  child: Text(
                '3/4',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
              onTap: () {
                FlameAudio.play('correct-answer.mp3');
                score += 3;

                randomize();
              },
            ),
          ),
        ],
      ),
    );
  }

  randomize() {
    setState(() {
      rand = Random().nextInt(11);
    });
  }

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
                  image: AssetImage('assets/images/gamebackground.png'),
                  fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              if (rand == 0) ball1(),
              if (rand == 1) ball2(),
              if (rand == 2) ball3(),
              if (rand == 3) ball4(),
              if (rand == 4) ball5(),
              if (rand == 5) ball6(),
              if (rand == 6) ball7(),
              if (rand == 7) ball8(),
              if (rand == 8) ball9(),
              if (rand == 9) ball10(),
              if (rand == 10) ball11(),
              if (rand == 11) ball12(),
              Align(
                alignment: Alignment(
                    (MediaQuery.of(context).size.width / -1.22) /
                        MediaQuery.of(context).size.width,
                    (MediaQuery.of(context).size.height / -1.37) /
                        MediaQuery.of(context).size.height),
                child: Container(
                  child: Image.asset(
                    'assets/images/Rectangle 47.png',
                  ),
                ),
              ),
              Align(
                alignment: Alignment(
                    (MediaQuery.of(context).size.width / -1.25) /
                        MediaQuery.of(context).size.width,
                    (MediaQuery.of(context).size.height / -1.37) /
                        MediaQuery.of(context).size.height),
                child: TweenAnimationBuilder<Duration>(
                    duration: Duration(seconds: 4),
                    tween:
                        Tween(begin: Duration(seconds: 4), end: Duration.zero),
                    onEnd: () {
                      FlameAudio.playLongAudio('Wrong answer.mp3');

                      if (health > 0) {
                        decreaseLife();
                      } else {
                        endgame();
                      }

                      randomize();
                    },
                    builder:
                        (BuildContext context, Duration value, Widget? child) {
                      final seconds = value.inSeconds;

                      final milliseconds = value.inMilliseconds % 100;

                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('$seconds:$milliseconds',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)));
                    }),
              ),
              Align(
                alignment: Alignment(
                    (MediaQuery.of(context).size.width / 1.22) /
                        MediaQuery.of(context).size.width,
                    (MediaQuery.of(context).size.height / -1.35) /
                        MediaQuery.of(context).size.height),
                child: Container(
                  child: Image.asset(
                    'assets/images/Rectangle 47.png',
                  ),
                ),
              ),
              Align(
                  alignment: Alignment(
                      (MediaQuery.of(context).size.width / 1.3) /
                          MediaQuery.of(context).size.width,
                      (MediaQuery.of(context).size.height / -1.43) /
                          MediaQuery.of(context).size.height),
                  child: Container(
                      child: Text(
                    '$score',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ))),
              Align(
                  alignment: Alignment(
                      (MediaQuery.of(context).size.width / 5) /
                          MediaQuery.of(context).size.width,
                      (MediaQuery.of(context).size.height / 1.25) /
                          MediaQuery.of(context).size.height),
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                            health,
                            (index) => Image.asset(
                                  'assets/images/gamebat1.png',
                                  height: 55,
                                  width: 55,
                                  fit: BoxFit.fill,
                                ))),
                  )),
              if (reviving) ...[
                Align(
                  alignment: Alignment(
                      (MediaQuery.of(context).size.width / -1.3) /
                          MediaQuery.of(context).size.width,
                      (MediaQuery.of(context).size.height / 1.25) /
                          MediaQuery.of(context).size.height),
                  child: TweenAnimationBuilder(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value as double,
                          child: child,
                        );
                      },
                      child: Image.asset('assets/images/gamebat1.png')),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
