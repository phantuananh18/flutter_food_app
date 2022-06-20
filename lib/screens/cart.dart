import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/home.dart';
import 'package:flutter_food_app/utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static String routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        backgroundColor: primaryColor,
      ),
    );
  }
}
