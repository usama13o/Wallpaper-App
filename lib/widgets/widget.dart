import 'package:flutter/material.dart';
import 'package:wallpaperhubclone/model/wallpaperModel.dart';

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wallpaper",
        style: TextStyle(color: Colors.black87, fontFamily: 'Overpass'),
      ),
      Text(
        "HubaDUBYo",
        style: TextStyle(color: Colors.blue, fontFamily: 'Overpass'),
      )
    ],
  );
}

Widget wallpaperslist({List<wallpaperModel> wallpapers, context}) {
  return Container(
                color: Colors.blue[200],

    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: .5,
      padding: EdgeInsets.symmetric(horizontal: 2),
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: Container(
            child:ClipRRect(
              child: Image.network(wallpaper.src.portrait,fit: BoxFit.cover,),
              borderRadius: BorderRadius.circular(15),
          )),
        );
      }).toList(),
    ),
  );
}
