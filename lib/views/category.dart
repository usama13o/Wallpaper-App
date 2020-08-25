import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhubclone/data/data.dart';
import 'package:wallpaperhubclone/model/wallpaperModel.dart';
import 'package:wallpaperhubclone/widgets/widget.dart';

class Categoriesview extends StatefulWidget {

   final String query;
  Categoriesview({this.query});
  @override
  _CategoriesviewState createState() => _CategoriesviewState();
}



class _CategoriesviewState extends State<Categoriesview> {
    List<wallpaperModel> wallpapers = new List();

getSearchWallpapers(String searchQuery) async {
    var response = await http.get(
        "https://api.pexels.com/v1/search?query=$searchQuery&per_page=30&page=1",
        headers: {"Authorization": apiKEY});
    print(response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element); to rpint each elemnt in array of photo details
      wallpaperModel wallpaper = new wallpaperModel();
      wallpaper = wallpaperModel.fromMap(element);
      wallpapers.add(wallpaper);
    });

    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.query);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              
              SizedBox(
                height: 20,
              ),
              wallpaperslist(wallpapers: wallpapers, context: context)
            ],
          ),
        ),
      ),
    );
  }
}