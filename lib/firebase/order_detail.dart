import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_food_app/models/detail_cart.dart';

class OrderDetailFirebase {
  CollectionReference orderdetails = FirebaseFirestore.instance.collection('detail_cart');

  Future<void> addOrderDetail(String idOrder, int idProduct, int quantity, double total) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyyMMddhhmmss').format(now);
    orderdetails.doc(currentDate + uid).set({
      'id': currentDate + uid,
      'idCart': idOrder,
      'idProduct': idProduct,
      'amount': quantity,
      'total': total
    });
  }

  Future getListDetailOrder() async {
    List<DetailCartModel> itemList = [];
    final shoppingCartId = FirebaseFirestore.instance.collection('detail_cart');
    await shoppingCartId.get().then((value) => value.docs.forEach((element) {
          itemList.add(DetailCartModel.fromMap(element.data()));
        }));
    return itemList;
  }

  Future getDetailOrder(String? id) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<DetailCartModel> itemList = [];
    var result = await orderdetails.where('id', isEqualTo: id).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(DetailCartModel.fromJson(result.docs[i]));
    }
    return itemList;
  }
}
