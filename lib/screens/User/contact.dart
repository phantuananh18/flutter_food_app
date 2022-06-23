import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

final nameEditingController = TextEditingController();
final subjectEditingController = TextEditingController();
final emailEditingController = TextEditingController();
final contentEditingController = TextEditingController();

Future sendEmail() async {
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId = "service_jwt3ymg";
  const templateId = "template_47028g9";
  const userId = "YWJFmAQ7dW7rLgbe8";
  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "name": nameEditingController.text,
          "subject": subjectEditingController.text,
          "message": contentEditingController.text,
          "user_email": emailEditingController.text,
        }
      }));

  print(response.body);
  Fluttertoast.showToast(msg: 'Đã gửi', fontSize: 18.0, backgroundColor: primaryColor);
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Liên hệ'),
        ),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  const Text(
                    'Hotline: 0366671779',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Email: tuananh.61779@gmail.com',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: nameEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Tên người gửi",
                        prefixIcon: Icon(Icons.account_box)),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: subjectEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Chủ đề",
                        prefixIcon: Icon(Icons.subject)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: emailEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: contentEditingController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nội dung",
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        sendEmail();
                      },
                      child: const Text(
                        'GỬI',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(MediaQuery.of(context).size.width, 50)),
                      )),
                ],
                // mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          )),
        ),
      ),
    );
  }
}
