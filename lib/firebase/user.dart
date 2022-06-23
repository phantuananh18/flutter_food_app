import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/models/user.dart';

class UserFirebase {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future getAll() async {
    await Firebase.initializeApp();

    List<UserModel> itemList = [];
    await users.get().then((value) => value.docs.forEach((element) {
          itemList.add(UserModel.fromMap(element.data()));
        }));
    return itemList;
  }

  Future getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<UserModel> itemList = [];
    var result = await users.where('uid', isEqualTo: uid).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(UserModel.fromJson(result.docs[i]));
    }
    UserModel item = itemList.firstWhere((element) => element.uid == uid);

    return item;
  }
}
