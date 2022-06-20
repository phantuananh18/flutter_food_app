// ignore_for_file: unused_field, avoid_unnecessary_containers
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/home.dart';
import 'package:flutter_food_app/screens/register.dart';
import 'package:flutter_food_app/screens/reset_password.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //edit controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //setState
  String _email = "";
  String _password = "";

  //firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? errorMessage;

  //Func Login
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password).then((uid) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'THÀNH CÔNG',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  content:
                      const Text('Bạn đã đăng nhập thành công!', style: TextStyle(fontSize: 18.0)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popAndPushNamed(HomeScreen.routeName)
                              .then((value) => _formKey.currentState!.reset());
                        },
                        child: const Text('OK', style: TextStyle(fontSize: 16.0)))
                  ],
                );
              });
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Địa chỉ email của bạn không đúng định dạng.";
            break;
          case "wrong-password":
            errorMessage = "Mật khẩu của bạn không đúng.";
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
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'THẤT BẠI',
                  style: TextStyle(fontSize: 25.0),
                ),
                content: Text(errorMessage!, style: const TextStyle(fontSize: 18.0)),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _formKey.currentState!.reset();
                      },
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(fontSize: 16.0),
                      ))
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool obscureText = false;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Vui lòng nhập email của bạn");
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return ("Email không hợp lệ");
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                        prefixIcon: Icon(Icons.mail_outline)),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    }),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscureText,
                  validator: (value) {
                    RegExp regex = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}");
                    if (value!.isEmpty) {
                      return ("Vui lòng nhập mật khẩu");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Mật khẩu trên 8 kí tự, 1 in hoa, 1 in thường và 1 số");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Mật khẩu",
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                        onPressed: () => setState(() {
                              obscureText = !obscureText;
                            }),
                        icon: obscureText
                            ? const Icon(
                                Icons.visibility,
                              )
                            : const Icon(
                                Icons.visibility_off,
                              )),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      signIn(emailController.text, passwordController.text);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width, 50)),
                    ),
                    child: const Text(
                      'ĐĂNG NHẬP',
                      style: TextStyle(fontSize: 18.0),
                    )),
                const SizedBox(
                  height: 5.0,
                ),
                TextButton(
                    onPressed: (() {
                      Navigator.of(context)
                          .push(
                              MaterialPageRoute(builder: (context) => const ResetPasswordScreen()))
                          .then((value) => _formKey.currentState!.reset());
                    }),
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(fontSize: 16.0, color: primaryColor),
                    )),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn chưa có tài khoản ?',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => const RegisterScreen()))
                              .then((value) => _formKey.currentState!.reset());
                        },
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(fontSize: 16.0, color: primaryColor),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  // ignore: sort_child_properties_last
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.all(10),
                        decoration:
                            const BoxDecoration(color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                        child: SvgPicture.asset('assets/icons/facebook-2.svg')),
                    Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.all(10),
                        decoration:
                            const BoxDecoration(color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                        child: SvgPicture.asset('assets/icons/google-icon.svg')),
                    Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.all(10),
                        decoration:
                            const BoxDecoration(color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                        child: SvgPicture.asset('assets/icons/twitter.svg')),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ],
            ),
          ),
        ),
      )),
      resizeToAvoidBottomInset: false,
    );
  }
}
