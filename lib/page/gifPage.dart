import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shopper/database/entity/favorite.dart';

class GifPage extends StatelessWidget {
  final Map gifData;
  final bool favorite;
  final Favorite gifDB;

  GifPage({this.gifData, this.gifDB, this.favorite = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(favorite?gifDB.title:gifData["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share),
              onPressed: () {
                Share.share(favorite?gifDB.url:gifData["images"]["fixed_height"]["url"]);
              }),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(favorite?gifDB.url:gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
