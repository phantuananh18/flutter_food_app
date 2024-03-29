import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_food_app/firebase/product.dart';
import 'package:flutter_food_app/models/product.dart';
import 'package:flutter_food_app/models/product_type.dart';
import 'dart:math';
import 'package:flutter_food_app/screens/Home/refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static String routeName = '/products';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> key = GlobalKey<RefreshIndicatorState>();
  List<ProductModel> _list = [];
  List<ProductTypeModel> _listCate = [];
  bool _isSelected = true;
  int _selectedIndex = -1;
  List<int> dataLoad = [];
  Future loadList() async {
    keyRefresh.currentState?.show();
    await Future.delayed(const Duration(microseconds: 4000));
    final randon = Random();
    final data = List.generate(100, (_) => randon.nextInt(100));
    if (mounted) {
      setState(() {
        dataLoad = data;
      });
    }
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  FetchData() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var result = await ProductFirebase().getAll();
    var category = await ProductFirebase().getAllCate();
    if (result == null) {
      print('unable');
    } else {
      setState(() {
        _list = result;
        _foundProduct = result;
        _listCate = category;
      });
    }
  }

  List<ProductModel> _foundProduct = [];
  @override
  void initState() {
    _foundProduct = _list;
    super.initState();
    FetchData();
  }

  void _FilterPro(int? idCate) {
    setState(() {
      _foundProduct = _list.where((e) => e.idTypeProduct == idCate).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          SizedBox(
              height: 50,
              child: Row(children: [
                SizedBox(
                  width: 100,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _foundProduct = _list;
                          _onSelected(-1);
                          _isSelected = true;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        decoration: BoxDecoration(
                            color: _isSelected ? primaryColor : Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(0))),
                        child: Text(
                          'Tất cả',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _isSelected ? Colors.white : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _listCate.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              _onSelected(index);
                              _isSelected = false;
                              _FilterPro(_listCate[index].idCate);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              padding: const EdgeInsets.all(10),
                              height: 30,
                              decoration: BoxDecoration(
                                  color:
                                      _selectedIndex == index ? Colors.teal.shade700 : Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(0))),
                              child: Text(
                                '${_listCate[index].nameCate}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _selectedIndex == index ? Colors.white : Colors.black,
                                ),
                              ),
                            ));
                      }),
                )
              ])),
          // Expanded(
          //     child: Container(
          //         margin: const EdgeInsets.all(5),
          //         child: RefreshWidget(
          //             onRefresh: loadList,
          //             key: key,
          //             keyRefresh: keyRefresh,
          //             child: StaggeredGrid.count(crossAxisCount: 3)
          //             ))))
        ],
      ),
    );
  }
}
