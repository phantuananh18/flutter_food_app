import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_food_app/firebase/order.dart';
import 'package:flutter_food_app/firebase/order_detail.dart';
import 'package:flutter_food_app/firebase/product.dart';
import 'package:flutter_food_app/models/detail_cart.dart';
import 'package:flutter_food_app/models/cart.dart';
import 'package:flutter_food_app/models/product.dart';
import 'package:flutter_food_app/screens/User/detail_history.dart';
import 'package:flutter_food_app/screens/checkout.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final controller = PageController();
  String uid = "";
  List<DetailCartModel> listProduct = [];
  List<CartModel> listOrder = [];
  // List<MDFeedback> listFeed = [];
  Future fetchUserInfo() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
  }

  List<ProductModel> listProductFeed = [];
  Future fetchProduct(String id) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    dynamic resultPro = await ProductFirebase().getProductId(id);

    if (resultPro == null) {
      print('unable');
    } else {
      if (this.mounted) {
        setState(() {
          listProductFeed = resultPro;
        });
      }
    }
  }

  Future fetchDataPro() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var result = await OrderFirebase().getListOrder(uid); //getListOrder
    var resultPro = await OrderDetailFirebase().getListDetailOrder();

    if (result == null) {
      print('unable');
    } else {
      if (this.mounted) {
        setState(() {
          listOrder = result;
          listProduct = resultPro;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserInfo();
    fetchDataPro();
    // FetchDataFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử'),
          backgroundColor: const Color.fromARGB(255, 29, 86, 110),
        ),
        body: DefaultTabController(
          length: 6,
          child: Column(
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.list,
                      color: Colors.black,
                    ),
                    // text: "Tất cả",
                    child: Text(
                      'Tất cả',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.schedule,
                      color: Colors.black,
                    ),
                    child: Text(
                      'Chờ xác nhận',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.task_alt,
                      color: Colors.black,
                    ),
                    child: Text(
                      'Đã xác nhận',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.delivery_dining,
                      color: Colors.black,
                    ),
                    child: Text(
                      'Đang giao hàng',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.cases_outlined,
                      color: Colors.black,
                    ),
                    child: Text(
                      'Giao hàng thành công',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.cancel_presentation,
                      color: Colors.black,
                    ),
                    child: Text(
                      'Đã hủy',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
                isScrollable: true,
              ),
              Expanded(
                  child: FutureBuilder(
                future: fetchDataPro(),
                builder: (context, snapshot) {
                  return snapshot.hasData || listOrder.isNotEmpty
                      ? TabBarView(
                          children: <Widget>[
                            Container(
                              child: all(),
                            ),
                            Container(
                              child: choXacNhan(),
                            ),
                            Container(
                              child: daXacNhan(),
                            ),
                            Container(
                              child: dangGiaoHang(),
                            ),
                            Container(
                              child: giaoThanhCong(),
                            ),
                            Container(
                              child: daHuy(),
                            ),
                          ],
                        )
                      : const Text('load');
                },
              )),
            ],
          ),
        ));
  }

  Widget all() {
    return Item(listOrder, listProduct);
  }

  Widget daHuy() {
    List<CartModel> listOrder1 = listOrder.where((element) => element.status == 'Cancel').toList();
    OrderDetailFirebase().getListDetailOrder();

    return Item(listOrder1, listProduct);
  }

  Widget giaoThanhCong() {
    List<CartModel> listOrder1 =
        listOrder.where((element) => element.status == 'Thành công').toList();

    return Item(listOrder1, listProduct);
  }

  Widget dangGiaoHang() {
    List<CartModel> listOrder1 =
        listOrder.where((element) => element.status == 'Đang giao hàng').toList();

    return Item(listOrder1, listProduct);
  }

  Widget daXacNhan() {
    List<CartModel> listOrder1 =
        listOrder.where((element) => element.status == 'Đã xác nhận').toList();

    return Item(listOrder1, listProduct);
  }

  Widget choXacNhan() {
    List<CartModel> listOrder1 = listOrder.where((element) => element.status == 'New').toList();

    return Item(listOrder1, listProduct);
  }

  Stack Item(List<CartModel> listOrder, List<DetailCartModel> listPro) {
    int indexOrder;

    return Stack(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: listOrder.length,
            itemBuilder: (context, index) {
              indexOrder = index;
              String idOrder = listOrder[index].idCart.toString();

              List<DetailCartModel> listProduct1 =
                  listPro.where((element) => element.idCart == listOrder[index].idCart).toList();

              return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, DetailHistoryScreen.routeName,
                        arguments: listOrder[index].idCart.toString());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                'Mã đơn hàng: ${listOrder[index].idCart}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.teal.shade800,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text('${getStatus(listOrder[index].status!)}',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade600))
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${listOrder[index].timeStart}'),
                            Text(
                              'Tổng tiền: ${NumberFormat('###,###').format(double.parse(listOrder[index].total.toString()))}',
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            })
      ],
    );
  }
}

getStatus(String status) {
  var result = "";
  switch (status) {
    case 'New':
      {
        result = 'Mới';
      }
      break;

    case 'Cancel':
      {
        result = 'Đã hủy';
      }
      break;

    default:
      {
        result = 'Không xác định';
      }
      break;
  }
  return result;
}
