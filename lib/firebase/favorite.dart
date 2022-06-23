import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_food_app/models/favorite.dart';

class FirebaseFavorite {
  CollectionReference favorites = FirebaseFirestore.instance.collection('favorite');

  Future<void> add(int idPro) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    DateTime now = DateTime.now();
    String id = DateFormat('yyyyMMddhhmmss').format(now);
    favorites.doc(id + uid).set({'id': id + uid, 'idCustomer': uid, 'idProduct': idPro});
  }

  Future<FavoriteModel> getStatus(int idPro) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<FavoriteModel> itemList = [];
    var result = await favorites.where('idCustomer', isEqualTo: uid).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(FavoriteModel.fromJson(result.docs[i]));
    }
    FavoriteModel item = itemList.firstWhere((element) => element.idProduct == idPro,
        orElse: () => FavoriteModel(id: 'NULL'));
    return item;
  }

  Future<void> remove(String id) async {
    FirebaseFirestore.instance.collection('favorite').doc(id).delete();
  }

  getFavorites() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<FavoriteModel> itemList = [];
    var result = await favorites.where('idCustomer', isEqualTo: uid).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(FavoriteModel.fromJson(result.docs[i]));
    }
    return itemList;
  }
}
