import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/home.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static String routeName = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
      ),
    );
  }
}
