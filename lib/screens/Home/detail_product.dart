import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_food_app/firebase/favorite.dart';
import 'package:flutter_food_app/firebase/product.dart';
import 'package:flutter_food_app/global.dart';
import 'package:flutter_food_app/models/detail_cart.dart';
import 'package:flutter_food_app/models/product.dart';
import 'package:flutter_food_app/models/favorite.dart';

// ignore: must_be_immutable
class DetailProductScreen extends StatefulWidget {
  ProductModel product;
  DetailProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  String uid = "";
  bool isLogin = false;
  FavoriteModel? favo;
  // List<MDFeedback> mdFeedback = [];
  fetchFeed() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    //   dynamic result = await FirFeedback()
    //       .getListFeedbackPro(widget.detailProduct.id.toString());
    //   if (result == null) {
    //     print('unable');
    //   } else {
    //     setState(() {
    //       mdFeedback = result;
    //     });
    //   }
    // }
  }

  // List<MDDetailShoppingCart> listShopping = [];
  fetchUserInfo() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      uid = user.uid;
    }
  }

  List<ProductModel> listPro = [];

  fetchDataProduct() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    dynamic result =
        await ProductFirebase().getCateProductList(widget.product.idTypeProduct.toString());
    // dynamic resultshopping = await FirShoppingCart().getListShoppingCart(uid);
    if (result == null) {
      print('unable');
    } else {
      setState(() {
        listPro = result;
        // listShopping = resultshopping;
      });
    }
  }

  fetchFavorite() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var result = await FirebaseFavorite().getStatus(widget.product.id!);
    setState(() {
      if (result.id != 'NULL') {
        favo = result;
      } else {
        favo = null;
      }
    });
  }

  favorite() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseFavorite().add(widget.product.id!);
    await fetchFavorite();
  }

  unFavorite() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseFavorite().remove(favo!.id!);
    await fetchFavorite();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchUserInfo();
    fetchDataProduct();
    fetchFeed();
    fetchFavorite();
    if (currentUserGlb.uid != '') {
      isLogin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    int? id = widget.product.id;
    String? idProduct = widget.product.id.toString();
    String nameProduct = widget.product.name.toString();
    int? priceProduct = widget.product.price;
    String? imgProduct = widget.product.image;
    String descriptionProduct = widget.product.description.toString();
    int? statusProduct = widget.product.status;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(nameProduct),
          backgroundColor: const Color.fromARGB(255, 29, 86, 110),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                child: Image.network(imgProduct.toString()),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width / 1.5,
                          child: Text(
                            nameProduct,
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                        Text(
                          '${NumberFormat('###,###').format(int.parse(priceProduct.toString()))} VND',
                          style: const TextStyle(fontSize: 25, color: Colors.red),
                        )
                      ],
                    ),
                    Text(
                      statusProduct == 1 ? "Còn hàng" : "Hết hàng",
                      style: TextStyle(
                          fontSize: 16,
                          color: statusProduct == 1
                              ? const Color.fromARGB(255, 19, 117, 60)
                              : const Color.fromARGB(255, 165, 28, 13)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    'Mô tả',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(descriptionProduct.toString())
                ]),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      this.isLogin
                          ? ElevatedButton(
                              onPressed: () {
                                if (statusProduct == 1) {
                                  var cartItem = cartCTGioHang.firstWhere(
                                      (element) => element.idProduct == widget.product.id,
                                      orElse: () => DetailCartModel(id: ""));
                                  if (cartItem.id == "") {
                                    cartSanPhamGlb.add(widget.product);
                                    cartCTGioHang.add(DetailCartModel(
                                        idProduct: id, amount: 1, total: priceProduct?.toDouble()));
                                  } else {
                                    cartItem.amount = cartItem.amount! + 1;
                                    cartItem.total = cartItem.total! + priceProduct!;
                                  }
                                  Fluttertoast.showToast(msg: "Thêm vào giỏ hàng thành công");
                                } else {
                                  Fluttertoast.showToast(msg: "Sản phẩm đã hết hàng");
                                }
                              },
                              child: const Text(
                                'Thêm vào',
                                style: TextStyle(fontSize: 15),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                              ))
                          : SizedBox(),
                      this.isLogin
                          ? Container(
                              child: this.favo != null
                                  ? ElevatedButton(
                                      onPressed: () {
                                        unFavorite();
                                      },
                                      child: const Text(
                                        'Hủy yêu thích',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(primaryColor),
                                      ))
                                  : ElevatedButton(
                                      onPressed: () {
                                        favorite();
                                      },
                                      child: const Text(
                                        'Yêu thích',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 33, 171, 165)),
                                      )))
                          : SizedBox(),
                    ],
                  )
                ]),
              ),
            ]),
          ),
        ));
  }
}
