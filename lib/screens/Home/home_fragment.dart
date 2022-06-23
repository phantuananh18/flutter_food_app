import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/firebase/product.dart';
import 'package:flutter_food_app/models/product_type.dart';
import 'package:flutter_food_app/models/product.dart';
import 'package:flutter_food_app/screens/Home/item_product.dart';
import 'package:flutter_food_app/utils.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<ProductTypeModel> listCate = [];
  List<ProductModel> listPro = [];

  Future fetchData() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // dynamic result = await ProductFirebase().getAll();
    dynamic category = await ProductFirebase().getAllCate();
    if (category == null) {
      print('unable');
    } else {
      if (this.mounted)
        setState(() {
          // listPro = result;
          listCate = category;
        });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  int activeIndex = 0;
  final urlImgs = [
    'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1566478989037-eec170784d0b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1626082929543-5bab0f090c42?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://images.unsplash.com/photo-1628840042765-356cda07504e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80',
    'https://images.unsplash.com/photo-1629203851288-7ececa5f05c4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      const SizedBox(
        height: 10,
      ),
      CarouselSlider.builder(
        itemCount: urlImgs.length,
        itemBuilder: (context, index, realIndex) {
          final urlImg = urlImgs[index];
          return buildImage(urlImg, index);
        },
        options: CarouselOptions(
            autoPlayInterval: Duration(seconds: 1),
            height: 250,
            // enlargeCenterPage: true,
            // enlargeStrategy: CenterPageEnlargeStrategy.height,
            viewportFraction: 1,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            }),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: urlImgs.map((url) {
            int index = urlImgs.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeIndex == index ? primaryColor : Color.fromARGB(255, 213, 213, 213),
              ),
            );
          }).toList()),
      SizedBox(height: 20),
      SizedBox(
        child: Text('Danh mục',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor)),
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        child: Container(
          height: 150,
          // Design Category
          child: _buildCategory(),
        ),
      ),
      // SizedBox(
      //   height: 10,
      // ),
      // SizedBox(
      //   child: Text('Nổi Bật',
      //       style: TextStyle(
      //           fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 22, 58, 95))),
      // ),
      // SizedBox(
      //   height: 10,
      // ),
      // SizedBox(
      //   child: Container(
      //     height: 270,
      //     child: _buildNewProduct(),
      //   ),
      // ),
    ])));
  }

  Widget buildImage(String urlImg, int index) => Container(
        // margin: EdgeInsets.symmetric(horizontal: 24),
        color: Colors.grey,
        child: Image.network(
          urlImg,
          width: 375,
          fit: BoxFit.cover,
        ),
      );

  Widget _buildCategory() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: listCate.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ProductsFragment()));
              },
              child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                            offset: const Offset(0, 15),
                            color: Colors.grey.shade300,
                            blurRadius: 10)
                      ],
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                                child: Image(
                              image: NetworkImage(listCate[index].imgCate.toString()),
                              fit: BoxFit.fitWidth,
                            ))),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 100,
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            '${listCate[index].nameCate}',
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 14, color: primaryColor, fontWeight: FontWeight.bold),
                          ))
                    ],
                  )));
        });
  }

  Widget _buildNewProduct() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(height: 180, child: ItemProductScreen(product: listPro[index]));
        },
        itemCount: listPro.length);
  }
}
