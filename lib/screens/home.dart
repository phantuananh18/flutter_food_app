import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/favorite.dart';
import 'package:flutter_food_app/screens/cart.dart';
import 'package:flutter_food_app/screens/notification.dart';
import 'package:flutter_food_app/screens/products.dart';
import 'package:flutter_food_app/screens/profile.dart';
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
    const ProductScreen(),
    const CartScreen(),
    const ProfileScreen(),
    const FavoriteScreen(),
    const NotiScreen(),
  ];
  void initialState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icons.shopping_cart,
            text: 'Giỏ hàng',
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
    );
  }
}
