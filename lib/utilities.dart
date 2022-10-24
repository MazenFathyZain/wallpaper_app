import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

enum SetWallpaperAs{Home , Lock , Both}
const _SetAs = {
  SetWallpaperAs.Home: WallpaperManager.HOME_SCREEN,
  SetWallpaperAs.Lock: WallpaperManager.LOCK_SCREEN,
  // SetWallpaperAs.Both: WallpaperManager.BOTH_SCREENS,
};
Future<void> setWallpaper({@required BuildContext context, @required String url})async{
  var actionSheet = CupertinoActionSheet(
    title: Text("Set As"),
    actions: [
      CupertinoActionSheetAction(
          onPressed: (){
            Navigator.of(context).pop(SetWallpaperAs.Home);
          },
          child: Text("Home")
      ),
      CupertinoActionSheetAction(
          onPressed: (){
            Navigator.of(context).pop(SetWallpaperAs.Lock);
          },
          child: Text("Lock")
      ),
      CupertinoActionSheetAction(
          onPressed: (){
            Navigator.of(context).pop(SetWallpaperAs.Lock);
          },
          child: Text("Both")
      ),
    ],
  );


  SetWallpaperAs option = await showCupertinoModalPopup(context: context, builder: (context) => actionSheet);

  if(option != null){
    var cachedImage = await DefaultCacheManager().getSingleFile(url);

    if(cachedImage != null){
      var CroppedImage = await ImageCropper.cropImage(
        sourcePath:cachedImage.path,
        aspectRatio: CropAspectRatio(
          ratioX: MediaQuery.of(context).size.width,
          ratioY: MediaQuery.of(context).size.height,
        ),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: Colors.blue,
          hideBottomControls: true,
        ),
      );

      if(CroppedImage != null){
        var result  = await WallpaperManager.setWallpaperFromFile(cachedImage.path, _SetAs[option]);

        if(result != null){
          debugPrint(result);
        }
      }
    }
  }
}