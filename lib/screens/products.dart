import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/home.dart';
import 'package:flutter_food_app/utils.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static String routeName = '/products';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm'),
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
