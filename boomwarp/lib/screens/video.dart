import 'package:flutter/material.dart';
import 'package:boomwarp/searchpage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class video extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Boomwarp",
            style: TextStyle(
              color: Colors.indigo.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => search())),
                icon: Icon(Icons.search)),
          ],
          backgroundColor: Colors.grey[900],
        ),
        backgroundColor: Colors.grey[900],
      );
}
