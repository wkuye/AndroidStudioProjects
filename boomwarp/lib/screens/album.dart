import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'dart:typed_data';

class album extends StatefulWidget {
  @override
  _albumState createState() => _albumState();
}

class _albumState extends State<album> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<AlbumInfo> albums = [];
  @override
  void initState() {
    super.initState();
    getAlbum();
  }

  Future<List<AlbumInfo>> getAlbum() async {
    albums = await audioQuery.getAlbums();
    return albums;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: FutureBuilder(
        future: getAlbum(),
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
          List<AlbumInfo> albums = item.data;
          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {},
                  title: Text(
                    albums[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.indigo.shade300),
                  ),
                  subtitle: Text(
                    albums[index].artist,
                    style: TextStyle(color: Colors.white70),
                  ),
                  leading: (albums[index].albumArt == null)
                      ? FutureBuilder<Uint8List>(
                          future: audioQuery.getArtwork(
                              type: ResourceType.ALBUM,
                              id: albums[index].id,
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
