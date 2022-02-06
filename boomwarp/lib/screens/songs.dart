import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:boomwarp/searchpage.dart';
import 'album.dart';
import 'artist.dart';
import 'playlist.dart';
import 'list_song.dart';
import 'package:flutter/widgets.dart';

class songs extends StatefulWidget {
  @override
  _songsState createState() => _songsState();
}

class _songsState extends State<songs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                "Boomwarp",
                style: TextStyle(
                  color: Colors.indigo.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: TabBar(
                indicatorColor: Colors.indigo.shade300,
                labelColor: Colors.indigo.shade300,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(icon: Icon(Icons.queue_music_rounded)),
                  Tab(icon: Icon(Icons.art_track)),
                  Tab(icon: Icon(Icons.album)),
                  Tab(
                    icon: Icon(Icons.playlist_play),
                  )
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => search())),
                    icon: Icon(Icons.search)),
              ],
              backgroundColor: Colors.grey[900],
            ),
            body: TabBarView(children: [
              slist(),
              artist(),
              album(),
              playlist(),
            ])));
  }
}
