import 'package:boomwarp/screens/songs.dart';
import 'dart:typed_data';
import 'screens/list_song.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_audio_query/flutter_audio_query.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController controller = TextEditingController();

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  List<AlbumInfo> albums = [];
  List<SongInfo> songs = [];
  Future _future;
  @override
  void initState() {
    super.initState();
    searchAlbums();
    searchSongs(searchString);
    _future = searchSongs(searchString);
  }

  Future<List<AlbumInfo>> searchAlbums() async {
    albums = await audioQuery.searchAlbums();
  }

  Future<List<SongInfo>> searchSongs(String searchString) async {
    songs = await audioQuery.searchSongs(query: searchString);
    return songs;
  }

  String searchString = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        toolbarHeight: 60.0,
        title: TextField(
          onChanged: (searchstring) async {
            await searchSongs(searchstring);
            setState(() {});
          },
          controller: controller,
          cursorColor: Colors.indigo[300],
          decoration: InputDecoration(
              hintText: " Search songs, albums, artist....",
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.indigo[300],
                  onPressed: () {
                    controller.clear();
                  })),
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder(
          future: _future,
          builder: (context, item) {
            // Load items

            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, i) {
                if (controller.text.isNotEmpty) {
                  return ListTile(
                      title: Text(
                        ('${songs[i].title}'),
                        style: TextStyle(color: Colors.indigo.shade300),
                      ),
                      subtitle: Text(
                        songs[i].artist,
                        style: TextStyle(color: Colors.white70),
                      ),
                      leading: (songs[i].albumArtwork == null)
                          ? FutureBuilder<Uint8List>(
                              future: audioQuery.getArtwork(
                                  type: ResourceType.SONG,
                                  id: songs[i].id,
                                  size: Size(100, 100)),
                              builder: (_, snapshot) {
                                if (snapshot.data == null)
                                  return CircleAvatar(
                                    child: CircularProgressIndicator(),
                                  );
                                if (snapshot.data.isEmpty)
                                  return CircleAvatar(
                                    backgroundColor: Colors.grey.shade800,
                                    child: Icon(
                                      Icons.music_note,
                                      color: Colors.grey.shade900,
                                    ),
                                  );
                                return CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: MemoryImage(
                                    snapshot.data,
                                  ),
                                );
                              })
                          : null);
                } else {
                  return null;
                }
              },
            );
          }),
    );
  }
}
