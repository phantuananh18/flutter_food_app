// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static String routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  String _email = '';
  String? errorMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        Navigator.of(context).pop();
        _formKey.currentState!.reset();
        Fluttertoast.showToast(
            msg: 'Vui lòng check email của bạn', fontSize: 18.0, backgroundColor: primaryColor);
      });
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case "invalid-email":
          errorMessage = "Địa chỉ email của bạn không đúng định dạng.";
          break;
        case "user-not-found":
          errorMessage = "Email của bạn không tồn tại.";
          break;
        case "user-disabled":
          errorMessage = "Email của bạn đã bị vô hiệu hóa.";
          break;
        case "too-many-requests":
          errorMessage = "Quá nhiều yêu cầu";
          break;
        case "operation-not-allowed":
          errorMessage = "Đăng nhập bằng email và mật khẩu chưa được bật.";
          break;
        default:
          errorMessage = "Đã xảy ra lỗi không xác định.";
      }
      Fluttertoast.showToast(msg: errorMessage!, fontSize: 18.0, backgroundColor: primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.asset('assets/images/logo.png'),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập email của bạn';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return ("Email không hợp lệ");
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập email',
                      prefixIcon: Icon(Icons.email)),
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: (() => resetPassword(emailController.text)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width, 50))),
                  child: const Text(
                    'Đặt lại mật khẩu',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _formKey.currentState!.reset();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width, 50))),
                  child: const Text(
                    'Quay lại đăng nhập',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            )),
      )),
    );
  }
}
