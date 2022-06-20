// ignore_for_file: deprecated_member_use, unused_field
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/screens/edit_profile.dart';
import 'package:flutter_food_app/screens/home.dart';
import 'package:flutter_food_app/screens/login.dart';
import 'package:flutter_food_app/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String routeName = '/profile';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  String? errorMessage;
  File? _image;

  void initialState() {
    super.initState();
    fetchData();
  }

  //fetch data
  Future fetchData() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) {
      userModel = UserModel.fromMap(value.data());
    });
    return userModel;
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }

  getCall() async {
    await launch('tel:${userModel.phone}');
  }

  getMail() async {
    await launch('mailto:${userModel.email}?subject=Subject mail&body=Body mail');
  }

  getMap() async {
    await launch('https://www.google.com/maps/place/${userModel.address}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin'),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false),
        ),
        actions: [IconButton(onPressed: () => logout(context), icon: const Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
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
                          DetailItem(
                              title: 'Full name: ${userModel.name}',
                              icon: Icons.account_circle_rounded),
                          DetailItem(
                            title: 'Email: ${userModel.email}',
                            icon: Icons.email,
                            onTap: () => getMail(),
                          ),
                          DetailItem(title: 'Gender: ${userModel.gender}', icon: Icons.transgender),
                          DetailItem(title: 'Birthday: ${userModel.birth}', icon: Icons.cake),
                          DetailItem(
                            title: 'Phone: ${userModel.phone}',
                            icon: Icons.phone,
                            onTap: () => getCall(),
                          ),
                          DetailItem(
                            title: 'Address: ${userModel.address}',
                            icon: Icons.location_on_rounded,
                            onTap: () => getMap(),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popAndPushNamed(EditProfile.routeName);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(MediaQuery.of(context).size.width, 50)),
                              ),
                              child: const Text(
                                'Cập nhật thông tin',
                                style: TextStyle(fontSize: 18.0),
                              )),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('Đang tải...'),
                    );
            },
          ),
        ),
      ),
    );
  }
}

//Create Detai
class DetailItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? sub;
  final Function()? onTap;
  const DetailItem({Key? key, required this.title, required this.icon, this.sub, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            elevation: MaterialStateProperty.all(5)),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              size: 25,
              color: Colors.black,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              title,
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
            )),
          ],
        ),
      ),
    );
  }
}
