import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'dart:typed_data';

class artist extends StatefulWidget {
  @override
  _artistState createState() => _artistState();
}

class _artistState extends State<artist> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<ArtistInfo> artists = [];
  @override
  void initState() {
    super.initState();
    getArtists();
  }

  Future<List<ArtistInfo>> getArtists() async {
    artists = await audioQuery.getArtists();
    return artists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: FutureBuilder(
        future: getArtists(),
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
          List<ArtistInfo> artists = item.data;
          return ListView.builder(
            itemCount: artists.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {},
                  title: Text(
                    artists[index].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.indigo.shade300),
                  ),
                  subtitle: Text(
                    " Songs: ${artists[index].numberOfTracks}",
                    style: TextStyle(color: Colors.white70),
                  ),
                  leading: (artists[index].artistArtPath == null)
                      ? FutureBuilder<Uint8List>(
                          future: audioQuery.getArtwork(
                              type: ResourceType.ARTIST,
                              id: artists[index].id,
                              size: Size(100, 100)),
                          builder: (_, snapshot) {
                            if (snapshot.data == null)
                              return Card(
                                elevation: 5,
                                child: CircularProgressIndicator(),
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
