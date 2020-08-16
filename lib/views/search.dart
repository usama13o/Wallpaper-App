import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperhubclone/widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhubclone/data/data.dart';
import 'package:wallpaperhubclone/model/wallpaperModel.dart';

class Search extends StatefulWidget {
  final String query;
  Search({this.query});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchcontroller = new TextEditingController();
  List<wallpaperModel> wallpapers = new List();

  @override
  void initState() {
    getSearchWallpapers(widget.query);
    // TODO: implement initState
    super.initState();
    searchcontroller.text = widget.query;
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchcontroller,
                        decoration: InputDecoration(
                          hintText: "search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          getSearchWallpapers(searchcontroller.text);
                        },
                        child: Container(child: Icon(Icons.search))),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Color(Colors.blue[50].hashCode),
                    borderRadius: BorderRadius.circular(10)),
              ),
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
