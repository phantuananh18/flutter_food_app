import 'package:flutter/material.dart';
import 'package:flutter_food_app/global.dart';
import 'package:flutter_food_app/screens/Home/guest_drawer.dart';
import 'package:flutter_food_app/screens/Home/home_fragment.dart';
import 'package:flutter_food_app/screens/Home/product_fragment.dart';
import 'package:flutter_food_app/screens/Home/user_drawer.dart';
import 'package:flutter_food_app/screens/favorite.dart';
import 'package:flutter_food_app/screens/cart.dart';
import 'package:flutter_food_app/screens/notification.dart';
import 'package:flutter_food_app/screens/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_food_app/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool isLogin = false;
  List<Widget> screens = [
    const HomeFragment(),
    const ProductsFragment(),
    const ProfileScreen(),
    const FavoriteScreen(),
    const NotiScreen(),
  ];
  void initialState() {
    super.initState();
    if (currentUserGlb.uid != '') {
      isLogin = true;
      print(isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_sharp)),
          IconButton(
              onPressed: () {
                if (currentUserGlb.uid != '') {
                  Navigator.pushNamed(context, CartScreen.routeName);
                } else {
                  Fluttertoast.showToast(
                      msg: 'Vui lòng đăng nhập', backgroundColor: primaryColor, fontSize: 18.0);
                }
              },
              icon: const Icon(Icons.shopping_bag))
        ],
        backgroundColor: primaryColor,
        title: const Center(
          child: Text('A2T Food'),
        ),
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: GNav(
        rippleColor: Colors.white,
        hoverColor: Colors.white,
        tabBorderRadius: 0,
        tabActiveBorder: Border.all(color: primaryColor, width: 1),
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 100),
        gap: 8,
        color: const Color.fromARGB(255, 255, 255, 255),
        activeColor: primaryColor,
        iconSize: 30.0,
        tabBackgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        backgroundColor: primaryColor,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Trang chủ',
          ),
          GButton(
            icon: Icons.list,
            text: 'Sản phẩm',
          ),
          GButton(
            icon: Icons.person,
            text: 'Thông tin',
          ),
          GButton(icon: Icons.favorite, text: 'Yêu thích'),
          GButton(
            icon: Icons.notifications_active,
            text: 'Thông báo',
          )
        ],
        onTabChange: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      drawer: isLogin ? const UserDrawer() : GuestDrawer(homeContext: context),
    );
  }
}
