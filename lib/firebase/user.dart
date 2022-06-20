import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_food_app/models/user.dart';

class UserFirebase {
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  Future getAll() async {
    await Firebase.initializeApp();

    List<UserModel> itemList = [];
    // ignore: avoid_function_literals_in_foreach_calls
    await users.get().then((value) => value.docs.forEach((element) {
          itemList.add(UserModel.fromMap(element.data()));
        }));

    return itemList;
  }
}
