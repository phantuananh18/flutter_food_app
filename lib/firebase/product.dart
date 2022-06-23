// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/models/product_type.dart';
import 'package:flutter_food_app/models/product.dart';

class ProductFirebase {
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference categories = FirebaseFirestore.instance.collection('product_type');

  //lấy sản phẩm list
  Future getAll() async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<ProductModel> itemList = [];
    await products.get().then((value) => value.docs.forEach((element) {
          itemList.add(ProductModel.fromJson(element.data()));
        }));
    print('itemList ${itemList}');
    return itemList;
  }

  //lấy loại sản phẩm list
  Future getAllCate() async {
    await Firebase.initializeApp();
    List<ProductTypeModel> listCategory = [];
    await categories.get().then((value) => value.docs.forEach((element) {
          listCategory.add(ProductTypeModel.fromJson(element.data()));
        }));
    print('itemList ${listCategory}');

    return listCategory;
  }

  //lấy id sản phẩm
  Future getProductId(String? id) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<ProductModel> itemList = [];
    ProductModel? item;
    await products.get().then((value) => value.docs.forEach((element) {
          (element) {
            itemList.add(ProductModel.fromJson(element.data()));
          };
        }));
    List<ProductModel> itemList1 = itemList.where((element) => element.id == id).toList();
    item = itemList1[0];
    return itemList1[0];
  }

  Future getCateProductList(String category) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<ProductModel> itemList = [];
    await products
        .where('idTypeProduct', isEqualTo: category)
        .get()
        .then((value) => value.docs.forEach((element) {
              itemList.add(ProductModel.fromJson(element.data()));
            }));
    print('itemList ${itemList}');

    return itemList;
  }

  Future getProduct(int? id) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
    List<ProductModel> itemList = [];
    var result = await products.where('id', isEqualTo: id).get();
    for (var i = 0; i < result.docs.length; i++) {
      itemList.add(ProductModel.fromJson(result.docs[i]));
    }
    ProductModel item = itemList.firstWhere((element) => element.id == id);
    print('itemList ${itemList}');

    return item;
  }
}
