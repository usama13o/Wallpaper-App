import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;

  ImageView({@required this.imgUrl});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (kIsWeb) {
                        _launchURL(widget.imgUrl);
                        //js.context.callMethod('downloadUrl',[widget.imgPath]);
                        //response = await dio.download(widget.imgPath, "./xx.html");
                      } else {
                        _save();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.white24,
                            Colors.black26,
                          ]),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white)),
                      child: Column(
                        children: [
                          Text("Set Wallpaper"),
                          Text("Image will be saved in gallery"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Cancel", style: TextStyle(color: Colors.white24)),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _save() async {
    await _askPermission();
    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */
      await PermissionHandler().requestPermissions([PermissionGroup.photos]);
    } else {
      /* PermissionStatus permission = */ await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}
