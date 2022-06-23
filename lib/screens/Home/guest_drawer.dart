import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/User/contact.dart';
import 'package:flutter_food_app/screens/login.dart';
import 'package:flutter_food_app/screens/register.dart';
import 'package:flutter_food_app/utils.dart';

class GuestDrawer extends StatefulWidget {
  final BuildContext homeContext;
  const GuestDrawer({Key? key, required this.homeContext}) : super(key: key);

  @override
  State<GuestDrawer> createState() => _GuestDrawerState();
}

class _GuestDrawerState extends State<GuestDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://icon-library.com/images/icon-user/icon-user-19.jpg')),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            textColor: const Color.fromARGB(255, 1, 1, 1),
            title: const Text(
              'Đăng nhập',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            textColor: const Color.fromARGB(255, 1, 1, 1),
            title: const Text(
              'Đăng ký',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            onTap: () {
              Navigator.pushNamed(context, RegisterScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text(
              'Liên hệ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
