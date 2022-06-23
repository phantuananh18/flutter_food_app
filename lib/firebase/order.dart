import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_food_app/models/cart.dart';

class OrderFirebase {
  CollectionReference orders = FirebaseFirestore.instance.collection('cart');

  Future addOrder(String idAddress, double total, String idPromotion) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyyMMddhhmmss').format(now);
    String currentDate2 = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    orders.doc(currentDate + uid).set({
      'idCart': currentDate + uid,
      'idDelivery': idAddress,
      'timeStart': currentDate2,
      'status': 'New',
      'idCustomer': uid,
      'idVoucher': idPromotion,
      'total': total
    });
    return currentDate + uid;
  }

  Future getListOrder(String id) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<CartModel> itemList = [];
    final shoppingCartId =
        FirebaseFirestore.instance.collection('cart').where('idCustomer', isEqualTo: id);
    await shoppingCartId.get().then((value) => value.docs.forEach((element) {
          itemList.add(CartModel.fromMap(element.data()));
        }));
    return itemList;
  }

  Future updateOrder(String idPro) async {
    String? id;
    String status = 'Đã hủy';
    final shoppingCartId =
        FirebaseFirestore.instance.collection('cart').where('idCart', isEqualTo: idPro);
    await shoppingCartId.get().then((value) => value.docs.forEach((element) {
          id = element.id;
        }));
    // print(shoppingCartId.id);
    FirebaseFirestore.instance.collection('cart').doc(id).update({'status': status});
  }

  Future getOrder(String? id) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<CartModel> itemList = [];
    var result = await orders.where('idCart', isEqualTo: id).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(CartModel.fromJson(result.docs[i]));
    }
    CartModel item = itemList.firstWhere((element) => element.idCart == id);

    return item;
  }

  Future cancelOrder(String idOrder) async {
    String status = 'Cancel';
    final shoppingCartId =
        FirebaseFirestore.instance.collection('cart').where('idCart', isEqualTo: idOrder);
    await shoppingCartId.get().then((value) => value.docs.forEach((element) {
          idOrder = element.id;
        }));
    // print(shoppingCartId.id);
    FirebaseFirestore.instance.collection('cart').doc(idOrder).update({'status': status});
  }
}
