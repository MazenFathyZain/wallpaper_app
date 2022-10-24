import 'dart:io';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:wallpaper/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter/services.dart';

import '../utilities.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  String _wallpaperFile = 'Unknown';
  var _image;
  bool opened = false;
  int quantity = 1;

  void pro(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Model images1 = ModalRoute.of(context).settings.arguments;
    String img = images1.image;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Image.network(
                  images1.image,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * .4,
                      color:
                          Color(IconTheme.of(context).color.value ^ 0xffffff),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.file_download),
                              onPressed: () async {
                                var imageId =
                                    await ImageDownloader.downloadImage(img);
                                var path =
                                    await ImageDownloader.findPath(imageId);
                                File image = File(path);
                                setState(() {
                                  _image = image;
                                });
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Download completed"),
                                  // action: SnackBarAction(
                                  //   label: "Open",
                                  //   onPressed: () async {
                                  //     var path =
                                  //     await ImageDownloader.findPath(
                                  //         imageId);
                                  //     await ImageDownloader.open(path);
                                  //   },
                                  // ),
                                ));
                              }),
                          IconButton(
                              icon: Icon(Icons.format_paint),
                              onPressed: () async {
                                var actionSheet = CupertinoActionSheet(
                                  title: Text("Set As"),
                                  actions: [
                                    CupertinoActionSheetAction(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _wallpaperFile = "Loading";
                                          });
                                          String result;
                                          var file = await DefaultCacheManager()
                                              .getSingleFile(
                                            images1.image,
                                          );
                                          // Platform messages may fail, so we use a try/catch PlatformException.
                                          try {
                                            result = await WallpaperManager
                                                .setWallpaperFromFile(
                                                    file.path,
                                                    WallpaperManager
                                                        .HOME_SCREEN);
                                          } on PlatformException {
                                            result = 'Failed to get wallpaper.';
                                          }
                                          if (!mounted) return;
                                          setState(() {
                                            _wallpaperFile = result;
                                          });
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("success"),
                                          ));
                                        },
                                        child: Text("Home")),
                                    CupertinoActionSheetAction(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _wallpaperFile = "Loading";
                                          });
                                          String result;
                                          var file = await DefaultCacheManager()
                                              .getSingleFile(
                                            images1.image,
                                          );
                                          // Platform messages may fail, so we use a try/catch PlatformException.
                                          try {
                                            result = await WallpaperManager
                                                .setWallpaperFromFile(
                                                    file.path,
                                                    WallpaperManager
                                                        .LOCK_SCREEN);
                                          } on PlatformException {
                                            result = 'Failed to get wallpaper.';
                                          }
                                          if (!mounted) return;
                                          setState(() {
                                            _wallpaperFile = result;
                                          });
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("success"),
                                          ));
                                        },
                                        child: Text("Lock")),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                                SetWallpaperAs option =
                                    await showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => actionSheet);
                              }),
                          IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                Share.share(images1.image);
                              }),
                        ],
                      )),
                )),
          ],
        );
      }),
    );
  }
}
