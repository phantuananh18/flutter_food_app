// ignore_for_file: file_names

import 'package:flutter_food_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);
  static String routeName = '/favorite';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu thích'),
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
