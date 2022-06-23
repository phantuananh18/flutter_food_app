import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_food_app/firebase/favorite.dart';
import 'package:flutter_food_app/firebase/product.dart';
import 'package:flutter_food_app/models/product.dart';
import 'package:flutter_food_app/models/favorite.dart';
import 'package:flutter_food_app/screens/Home/item_product.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<FavoriteModel> _list = [];
  List<ProductModel> _listPrd = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    fetchData();
  }

  fetchData() async {
    List<ProductModel> listPrd = [];
    List<FavoriteModel> list = [];
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var result = await FirebaseFavorite().getFavorites();
    list = result;

    for (var i = 0; i < list.length; i++) {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      var pro = await ProductFirebase().getProduct(list[i].idProduct);
      listPrd.add(pro);
    }

    setState(() {
      _list = result;
      _listPrd = listPrd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu thích'),
        backgroundColor: const Color.fromARGB(255, 29, 86, 110),
        leading: IconButton(
          alignment: Alignment.center,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
            child: StaggeredGridView.countBuilder(
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 5.0,
          itemCount: _listPrd.length,
          crossAxisCount: 4,
          itemBuilder: (BuildContext context, int index) => ItemProductScreen(
            product: _listPrd[index],
          ),
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
        )),
      ),
    );
  }
}
