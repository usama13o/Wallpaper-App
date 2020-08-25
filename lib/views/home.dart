import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperhubclone/data/data.dart';
import 'package:wallpaperhubclone/model/categories_model.dart';
import 'package:wallpaperhubclone/model/wallpaperModel.dart';
import "package:wallpaperhubclone/widgets/widget.dart";
import 'package:http/http.dart' as http;
import 'category.dart';
import 'search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = new List();
  List<wallpaperModel> wallpapers = new List();

  TextEditingController searchcontroller = new TextEditingController();

  getTrendingWallpapers() async {
    var response = await http.get(
        "https://api.pexels.com/v1/curated?per_page=15&page=1",
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
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
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
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search(
                                        query: searchcontroller.text,
                                      )));
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
              Container(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoriesTile(
                      title: categories[index].categoriesName,
                      imgurl: categories[index].imgurl,
                    );
                  },
                ),
              ),
              wallpaperslist(wallpapers: wallpapers, context: context)
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgurl, title;
  CategoriesTile({@required this.title, @required this.imgurl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categoriesview(
                      query: this.title,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgurl,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26),
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
