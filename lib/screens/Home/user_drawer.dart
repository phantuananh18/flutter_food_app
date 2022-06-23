import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/firebase/user.dart';
import 'package:flutter_food_app/models/user.dart';
import 'package:flutter_food_app/screens/User/contact.dart';
import 'package:flutter_food_app/screens/login.dart';
import 'package:flutter_food_app/screens/profile.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  UserModel? loggedInuser;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var result = await UserFirebase().getUser();
    print('res ${result}');
    setState(() {
      loggedInuser = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 29, 86, 110),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: SizedBox(
                      height: 90,
                      width: 90,
                      child: loggedInuser != null
                          ? Image.network(loggedInuser!.avatar!)
                          : const SizedBox()),
                ),
                Center(
                  child: loggedInuser != null
                      ? Text("${loggedInuser!.name}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                              fontSize: 16))
                      : const Text(""),
                ),
                Center(
                  child: loggedInuser != null
                      ? Text("${loggedInuser!.email}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 12))
                      : const Text(""),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Thông tin tài khoản',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.history),
          //   title: const Text(
          //     'Lịch sử mua hàng',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const HistoryPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.heart_broken),
          //   title: const Text(
          //     'Yêu thích',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const LovePage()),
          //     );
          //   },
          // ),
          // ListTile(
          //     leading: const Icon(Icons.contact_mail),
          //     title: const Text(
          //       'Tin tức',
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     ),
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const NewsState()),
          //       );
          //     }),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text(
              'Liên hệ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactScreen()),
              );
            },
            // onTap: () async {
            //   await launch(
            //       'mailto:${loggedInuser.email}?subject=Thuc hanh mail&body=Quang Linh');
            // },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Đăng xuất',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
