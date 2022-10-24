
import 'package:wallpaper/models/constants.dart';
import 'package:wallpaper/models/model.dart';
import 'package:wallpaper/services/store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'full_sreen.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = "ca-app-pub-3940256099942544/6300978111";

class Home extends StatefulWidget {
  static String id = "Home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['wallpapers', 'walls',"gallery"],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
    );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-4271638239571403/9773763729",
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
      );
  }
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-4271638239571403/9964128197",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
      );
  }
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4271638239571403~4609759545");
   _bannerAd = createBannerAd()..load()..show();
  }
  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
  int count = 1;
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    MaterialApp(
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Images(),
    );
  }

  Widget Images() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Model> images = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data;
            images.add(Model(image: data()[location]));
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                if (count % 4 == 0) {
                  createInterstitialAd()
                    ..load()
                    ..show();
                }
                print("counter is" + count.toString());
                count++;
                Navigator.pushNamed(context, ProductInfo.id,
                    arguments: images[index]);
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(.5),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: 200.0,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(20.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            images[index].image,
                          ),
                        ),
                      ),
                    ),
                  ),
//                  Positioned.fill(
//                    child: Image(image: NetworkImage(images[index].image,),fit: BoxFit.cover,),
//                  ),
                ],
              ),
            ),
            itemCount: images.length,
          );
        } else {
          return Center(child: Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 20.0),));
        }
      },
    );
  }
}
