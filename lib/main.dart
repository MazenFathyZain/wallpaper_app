import 'package:wallpaper/screens/full_sreen.dart';
import 'package:wallpaper/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = 'wallpaper App';
    // TODO: implement build
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Home(),
      builder: (BuildContext context, Widget child){
        return Padding(
          child: child,
          padding: EdgeInsets.only(bottom: 60.0),
        );
      },
      routes: {
        Home.id: (context) => Home(),
        ProductInfo.id: (context) => ProductInfo(),
      },
      );
  }
}