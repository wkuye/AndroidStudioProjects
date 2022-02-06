import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:boomwarp/main.dart';
import 'package:just_audio/just_audio.dart';
import 'musicplayer.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class slist extends StatefulWidget {
  const slist({Key key}) : super(key: key);
  @override
  _slistState createState() => _slistState();
}

class _slistState extends State<slist> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final player = AudioPlayer();
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
  List<SongInfo> songs = [];

  @override
  void initState() {
    super.initState();
    getAllSongs();
  }

  Future<List<SongInfo>> getAllSongs() async {
    songs = await audioQuery.getSongs();
    return songs;
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('shuffle'),
        icon: Icon(
          Icons.shuffle,
          color: Colors.amber,
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: FutureBuilder(
        future: getAllSongs(),
        builder: (context, item) {
          if (item.data == null)
            return const Center(
              child: CircularProgressIndicator(),
            );

          // Empty list
          if (item.data.isEmpty) {
            return const Center(
              child: Text(
                "Nothing found!",
                style: TextStyle(
                  color: Colors.indigo,
                ),
                textScaleFactor: 2,
              ),
            );
          }

          // Load items
          List<SongInfo> songs = item.data;
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    currentIndex = index;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MusicPlayer(
                            changeTrack: changeTrack,
                            songInfo: songs[currentIndex],
                            key: key)));
                  },
                  title: Text(
                    songs[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.indigo.shade300),
                  ),
                  subtitle: Text(
                    songs[index].artist,
                    style: TextStyle(color: Colors.white70),
                  ),
                  leading: (songs[index].albumArtwork == null)
                      ? FutureBuilder<Uint8List>(
                          future: audioQuery.getArtwork(
                              type: ResourceType.SONG,
                              id: songs[index].id,
                              size: Size(100, 100)),
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
                                elevation: 5,
                                clipBehavior: Clip.antiAlias,
                                color: Colors.grey.shade800,
                                child: SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: Icon(
                                    Icons.music_note,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              );

                            return Card(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(snapshot.data)),
                              ),
//                         ),
                            );
                          })
                      : null);
            },
          );
        },
      ),
    );
  }
}
