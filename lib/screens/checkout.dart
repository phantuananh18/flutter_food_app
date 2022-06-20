import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/cart.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  static String routeName = '/checkout';

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh Toán'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, CartScreen.routeName);
          },
        ),
      ),
    );
  }
}
