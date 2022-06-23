import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_food_app/firebase/address.dart';
import 'package:flutter_food_app/firebase/order.dart';
import 'package:flutter_food_app/firebase/order_detail.dart';
import 'package:flutter_food_app/firebase/product.dart';
import 'package:flutter_food_app/models/detail_cart.dart';
import 'package:flutter_food_app/models/address.dart';
import 'package:flutter_food_app/models/cart.dart';
import 'package:flutter_food_app/models/product.dart';

class DetailHistoryScreen extends StatefulWidget {
  static String routeName = "/detail-history";
  const DetailHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DetailHistoryScreen> createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  String orderID = "";
  CartModel? order;
  AddressModel? address;
  List<DetailCartModel> details = [];
  List<ProductModel> products = [];
  double discount = 0;
  double sum = 0;

  fetchData(String orderID) async {
    List<ProductModel> products = [];
    await Firebase.initializeApp();
    var order = await OrderFirebase().getOrder(orderID);
    var details = await OrderDetailFirebase().getDetailOrder(orderID);
    var address = await FirebaseAddress().getAddress(order.idDelivery);
    for (var i = 0; i < details.length; i++) {
      var product = await ProductFirebase().getProduct(details[i].idProduct);
      products.add(product);
    }
    double sum = 0;
    for (var detail in details) {
      sum = sum + detail.total;
    }
    setState(() {
      this.orderID = orderID;
      this.order = order;
      this.details = details;
      this.products = products;
      this.address = address;
      this.sum = sum;
    });
  }

  cancelOrder() async {
    await Firebase.initializeApp();
    await OrderFirebase().cancelOrder(orderID);
    await fetchData(orderID);
    Fluttertoast.showToast(
        msg: "Hủy đơn hàng thành công.", fontSize: 18.0, backgroundColor: primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (orderID == "") {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      fetchData(args);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng'),
        backgroundColor: const Color.fromARGB(255, 29, 86, 110),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Thông tin giao hàng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                const SizedBox(height: 5),
                address != null ? Text("Tên người nhận:   " + address!.name!) : const Text(""),
                const SizedBox(height: 5),
                address != null ? Text("Số điện thoại:   " + address!.phone!) : const Text(""),
                const SizedBox(height: 5),
                address != null ? Text("Địa chỉ:   " + address!.address!) : const Text(""),
                const SizedBox(height: 5),
                const Text("Chi tiết đơn hàng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                const SizedBox(height: 5),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: Image.network(products[index].image!),
                          ),
                          SizedBox(
                            width: width - 140,
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    products[index].name! +
                                        " x " +
                                        details[index].amount.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Tổng: ' + details[index].total.toString())
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      );
                    }),
                SizedBox(
                  width: width - 50,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        "Thành tiền: " + this.sum.toString(),
                        textAlign: TextAlign.end,
                      )),
                ),
                SizedBox(height: 5),
                this.discount != 0
                    ? SizedBox(
                        width: width - 50,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              "Giảm giá: - " + this.discount.toString(),
                              textAlign: TextAlign.end,
                            )),
                      )
                    : SizedBox(
                        width: width - 50,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              "Giảm giá: 0",
                              textAlign: TextAlign.end,
                            )),
                      ),
                SizedBox(height: 5),
                SizedBox(
                  width: width - 50,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: this.order != null
                          ? Text(
                              "Tổng cộng: " + this.order!.total.toString(),
                              textAlign: TextAlign.end,
                            )
                          : Text("Tổng cộng: 0")),
                ),
                SizedBox(height: 5),
                Text("Thông tin đơn hàng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                SizedBox(height: 5),
                this.order != null ? Text("Ngày đặt:   " + this.order!.timeStart!) : Text(""),
                SizedBox(height: 5),
                this.order != null
                    ? Text("Tình trạng:   " + getStatus(this.order!.status!))
                    : Text(""),
                SizedBox(height: 5),
                this.order != null && this.order!.status == 'New'
                    ? ElevatedButton(
                        onPressed: () {
                          this.cancelOrder();
                        },
                        child: Text("Hủy đơn hàng"))
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
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
