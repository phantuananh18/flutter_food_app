import 'package:flutter_food_app/models/user.dart';
import 'package:flutter_food_app/models/product.dart';
import 'package:flutter_food_app/models/detail_cart.dart';

UserModel currentUserGlb = UserModel(uid: '');
List<ProductModel> cartSanPhamGlb = List<ProductModel>.empty(growable: true);
List<DetailCartModel> cartCTGioHang = List<DetailCartModel>.empty(growable: true);
