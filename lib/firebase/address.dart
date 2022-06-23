import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_food_app/models/address.dart';

class FirebaseAddress {
  CollectionReference addresses = FirebaseFirestore.instance.collection('Address');

  Future<void> addAddress(String name, String phoneNumber, String address) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    DateTime now = DateTime.now();
    String id = DateFormat('yyyyMMddhhmmss').format(now);
    addresses.doc(id + uid).set({
      'id': id + uid,
      'name': name,
      'phone': phoneNumber,
      'address': address,
      'idCustomer': uid
    });
  }

  Future getAddresses() async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    List<AddressModel> itemList = [];
    var result = await addresses.where('idCustomer', isEqualTo: uid).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(AddressModel.fromJson(result.docs[i]));
    }
    return itemList;
  }

  Future getAddress(String? id) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<AddressModel> itemList = [];
    var result = await addresses.where('id', isEqualTo: id).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(AddressModel.fromJson(result.docs[i]));
    }
    AddressModel item = itemList.firstWhere((element) => element.id == id);

    return item;
  }
}
