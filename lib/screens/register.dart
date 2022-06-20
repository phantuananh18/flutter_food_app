// ignore_for_file: unused_field, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/models/user.dart';
import 'package:flutter_food_app/screens/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_food_app/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //edit controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  //setState
  String _email = "";
  String _password = "";
  String _gender = "";
  String _phone = "";
  String _birth = "";
  String _confirmPassword = "";
  String _name = "";
  String _address = "";

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    genderController.dispose();
    phoneController.dispose();
    birthController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    addressController.dispose();
  }

  // ignore: unused_element
  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        birthController.text = '2002-11-22';
      });
    });
  }

  //firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;

  //Sign Up
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  postDetailsToFirestore(),
                })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser!;

    UserModel userModel = UserModel();

    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;
    userModel.birth = birthController.text;
    userModel.phone = phoneController.text;
    userModel.address = addressController.text;
    userModel.gender = genderController.text;
    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'THÀNH CÔNG',
              style: TextStyle(fontSize: 25.0),
            ),
            content: const Text('Bạn đã đăng nhập thành công!', style: TextStyle(fontSize: 18.0)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(LoginScreen.routeName)
                        .then((value) => _formKey.currentState!.reset());
                  },
                  child: const Text('OK', style: TextStyle(fontSize: 16.0)))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool obscureText = false;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ignore: avoid_unnecessary_containers
                Container(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Vui lòng nhập họ tên");
                    }
                    if (!RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                        .hasMatch(value)) {
                      return ("Họ tên không hợp lệ");
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Họ và tên",
                      prefixIcon: Icon(Icons.account_circle_rounded)),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: genderController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Vui lòng nhập giới tính");
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Giới tính',
                      prefixIcon: Icon(Icons.transgender)),
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Ngày sinh",
                      prefixIcon: Icon(Icons.cake)),
                  dateMask: 'dd/MM/yyyy',
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2025),
                  onChanged: (value) {
                    setState(() {
                      birthController.text = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Vui lòng chọn ngày sinh");
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập số điện thoại',
                      prefixIcon: Icon(Icons.phone)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ('Vui lòng nhập số điện thoại');
                    }
                    if (!RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b').hasMatch(value)) {
                      return ('Số điện thoại không hợp lệ');
                    }
                    return null;
                  },
                  controller: phoneController,
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
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
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureText,
                  validator: (value) {
                    if (confirmPasswordController.text != passwordController.text) {
                      return ("Mật khẩu không trùng khớp");
                    }
                    if (value!.isEmpty) {
                      return ("Vui lòng nhập lại mật khẩu");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Nhập lại mật khẩu",
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
                      _confirmPassword = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập địa chỉ',
                      prefixIcon: Icon(Icons.location_on)),
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ('Vui lòng nhập địa chỉ');
                    }
                    if (value.length > 300) {
                      return ('');
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      signUp(emailController.text, passwordController.text);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width, 50)),
                    ),
                    child: const Text(
                      'ĐĂNG KÝ',
                      style: TextStyle(fontSize: 18.0),
                    )),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn đã có tài khoản ?',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => const LoginScreen()))
                              .then((value) => _formKey.currentState!.reset());
                        },
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(fontSize: 16.0, color: primaryColor),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
      resizeToAvoidBottomInset: false,
    );
  }
}
