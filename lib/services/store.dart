import 'package:wallpaper/models/constants.dart';
import 'package:wallpaper/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  addImage(Model picture) {
    _firestore.collection(collection).add({
      location: picture.image,
    });
  }
  Stream<QuerySnapshot> loadProducts() {
    return _firestore.collection(collection).snapshots();
  }
}
