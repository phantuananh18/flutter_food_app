// ignore_for_file: unused_field, prefer_final_fields, depend_on_referenced_packages, unused_local_variable, avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_food_app/models/user.dart';
import 'package:flutter_food_app/screens/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  static String routeName = '/edit-profile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //form key
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  File? _image;
  UserModel userModel = UserModel();

  //firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;

  //edit controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  //setState
  String _email = "";
  String _gender = "";
  String _phone = "";
  String _birth = "";
  String _name = "";
  String _address = "";

  // ignore: unused_element
  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        birthController.text = '2002-11-22';
      });
    });
  }

  //getImage
  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
      print('Image Path ${_image}');
    });
  }

  //update name

  //upload picture
  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imgUrl = await taskSnapshot.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'avatar': imgUrl}).then((value) => null);
    setState(() {
      print('Profile pic uploaded');
      Fluttertoast.showToast(
          msg: 'Ảnh đại diện đã được thay đổi', fontSize: 18.0, backgroundColor: primaryColor);
    });
  }

  Future fetchData() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) {
      userModel = UserModel.fromMap(value.data());
    });
    return userModel;
  }

  @override
  Widget build(BuildContext context) {
    bool obscureText = false;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Cập nhật thông tin'),
      //   backgroundColor: primaryColor,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => const ProfileScreen()),
      //             (route) => false).then((value) => _formKey.currentState!.reset());
      //       },
      //       icon: const Icon(Icons.arrow_back)),
      // ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: primaryColor,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 190.0,
                                  height: 190.0,
                                  child: (_image != null)
                                      ? Image.file(
                                          _image!,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          // "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                          "${userModel.avatar}",
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 30.0,
                            ),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: nameController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "${userModel.name}",
                              prefixIcon: const Icon(Icons.account_circle_rounded)),
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          },
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
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: genderController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: '${userModel.gender}',
                              prefixIcon: const Icon(Icons.transgender)),
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Vui lòng nhập giới tính");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.date,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "${userModel.birth}",
                              prefixIcon: const Icon(Icons.cake)),
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
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: '${userModel.phone}',
                              prefixIcon: const Icon(Icons.phone)),
                          controller: phoneController,
                          onChanged: (value) {
                            setState(() {
                              _phone = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ('Vui lòng nhập số điện thoại');
                            }
                            if (!RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b').hasMatch(value)) {
                              return ('Số điện thoại không hợp lệ');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "${userModel.email}",
                              prefixIcon: const Icon(Icons.mail_outline)),
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Vui lòng nhập email của bạn");
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return ("Email không hợp lệ");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: '${userModel.address}',
                              prefixIcon: const Icon(Icons.location_on)),
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
                              // updateName();
                              uploadPic(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(MediaQuery.of(context).size.width, 50)),
                            ),
                            child: const Text(
                              'CẬP NHẬT',
                              style: TextStyle(fontSize: 18.0),
                            )),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('Đang tải...'),
                    );
            },
          ),
        ),
      )),
      resizeToAvoidBottomInset: false,
    );
  }
}
