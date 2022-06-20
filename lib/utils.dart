import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 254, 150, 85);

//Dialog
class CustomDialog {
  static makeDialog(
      {required BuildContext context,
      required String title,
      required String content,
      List<Widget>? actions}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: actions,
            ));
  }
}
