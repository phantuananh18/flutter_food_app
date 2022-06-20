import 'package:flutter/material.dart';
import 'package:flutter_food_app/screens/cart.dart';
import 'package:flutter_food_app/screens/checkout.dart';
import 'package:flutter_food_app/screens/edit_profile.dart';
import 'package:flutter_food_app/screens/home.dart';
import 'package:flutter_food_app/screens/login.dart';
import 'package:flutter_food_app/screens/products.dart';
import 'package:flutter_food_app/screens/profile.dart';
import 'package:flutter_food_app/screens/register.dart';
import 'package:flutter_food_app/screens/reset_password.dart';
import 'package:flutter_food_app/screens/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  CheckoutScreen.routeName: (context) => const CheckoutScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
  ProductScreen.routeName: (context) => const ProductScreen(),
  EditProfile.routeName: (context) => const EditProfile(),
};
