import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<MusicPlayerState> key;
  MusicPlayer({this.songInfo, this.changeTrack, this.key}) : super(key: key);
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  void dispose() {
    super.dispose();
    player?.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });

    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      if (currentValue >= maximumValue) {
        widget.changeTrack(true);
      }
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Widget build(context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey[800], Colors.black])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_sharp,
                    color: Colors.indigo[300])),
            title: Text('Now Playing',
                style: TextStyle(color: Colors.indigo[300])),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
            child: Column(children: <Widget>[
              Card(
                  child: (widget.songInfo.albumArtwork == null)
                      ? FutureBuilder<Uint8List>(
                          future: audioQuery.getArtwork(
                              type: ResourceType.SONG,
                              id: widget.songInfo.id,
                              size: Size(600, 600)),
                          builder: (_, snapshot) {
                            if (snapshot.data == null)
                              return Card(
                                elevation: 5,
                                color: Colors.grey.shade800,
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.grey.shade900,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              );
                            if (snapshot.data.isEmpty)
                              return Card(
                                margin: EdgeInsets.all(0),
                                elevation: 5,
                                clipBehavior: Clip.antiAlias,
                                color: Colors.grey.shade800,
                                child: SizedBox(
                                  height: 300.0,
                                  width: 350.0,
                                  child: Icon(
                                    Icons.music_note,
                                    size: 80.0,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              );

                            return Card(
                              margin: EdgeInsets.all(0),
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                height: 300.0,
                                width: 350.0,
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(snapshot.data),
                                  gaplessPlayback: true,
                                ),
                              ),
//                         ),
                            );
                          })
                      : null),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  widget.songInfo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.indigo[300],
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 33),
                child: Text(
                  widget.songInfo.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Slider(
                inactiveColor: Colors.black38,
                activeColor: Colors.indigo[300],
                min: minimumValue,
                max: maximumValue,
                value: currentValue,
                onChanged: (value) {
                  currentValue = value;
                  if (value >= maximumValue) {
                    widget.changeTrack(true);
                  }
                  player.seek(Duration(milliseconds: currentValue.round()));
                },
              ),
              Container(
                transform: Matrix4.translationValues(0, -15, 0),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentTime,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500)),
                    Text(endTime,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Icon(Icons.skip_previous,
                          color: Colors.grey[500], size: 55),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.changeTrack(false);
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: Colors.grey[500],
                          size: 85),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        changeStatus();
                      },
                    ),
                    GestureDetector(
                      child: Icon(Icons.skip_next,
                          color: Colors.grey[500], size: 55),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.changeTrack(true);
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
