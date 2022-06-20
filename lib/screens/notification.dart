import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/home.dart';
import 'package:flutter_food_app/utils.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({Key? key}) : super(key: key);
  static String routeName = '/notification';

  @override
  State<NotiScreen> createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
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
