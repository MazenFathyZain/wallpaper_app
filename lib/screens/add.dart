import 'dart:io';
import 'package:wallpaper/models/model.dart';
import 'package:wallpaper/services/store.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'home.dart';


class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  var _image;
  String _url;
  void loadImage() async {
    var imageId = await ImageDownloader.downloadImage(_url);
    var path = await ImageDownloader.findPath(imageId);
    File image = File(path);
    setState(() {
      _image = image;
    });
  }

//  void uploadImage(context) async {
//    try {
//      FirebaseStorage storage =
//          FirebaseStorage(storageBucket: "gs://wallpaper-d7ab7.appspot.com");
//      StorageReference ref = storage.ref().child(p.basename(_image.path));
//      StorageUploadTask storageUploadTask = ref.putFile(_image);
//      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text('success'),
//      ));
//      String url = await taskSnapshot.ref.getDownloadURL();
//      print('url $url');
//      setState(() {
//        _url = url;
//      });
//    } catch (ex) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text(ex.message),
//      ));
//    }
//  }

  void pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void pickImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("wallpaper app"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: _image == null ? null : FileImage(_image),
                  radius: 80,
                  backgroundColor: Colors.black,
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(onTap: pickImage, child: Icon(Icons.image)),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                        onTap: pickImage2, child: Icon(Icons.camera_alt)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(
                  builder: (context) => RaisedButton(
//                        color: kSecondaryColor,
                    onPressed: () {
//                      uploadImage(context);
                    },
                    child: Text('Upload Image'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
//                      color: kSecondaryColor,
                  onPressed: loadImage,
                  child: Text('Load Image'),
                )
              ],
            ),
            RaisedButton(
              child: Text("add images"),
              onPressed: () {
                _store.addImage(Model(image: _url));
              },
            ),
            RaisedButton(
              child: Text("home"),
              onPressed: () {
                Navigator.pushNamed(context, Home.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
