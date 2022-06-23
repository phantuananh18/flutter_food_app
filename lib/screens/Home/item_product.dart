import 'package:flutter/material.dart';
import 'package:flutter_food_app/models/product.dart';
import 'package:flutter_food_app/screens/Home/detail_product.dart';

// ignore: must_be_immutable
class ItemProductScreen extends StatefulWidget {
  ProductModel product;
  ItemProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ItemProductScreen> createState() => _ItemProductScreenState();
}

class _ItemProductScreenState extends State<ItemProductScreen> {
  @override
  Widget build(BuildContext context) {
    int isimportant = 0;
    // Favorites favorites = new Favorites(
    //     id: widget.detailProduct.id,
    //     isImportant: 0,
    //     idProduct: widget.detailProduct.id,
    //     productName: widget.detailProduct.namePro,
    //     categoryName: widget.detailProduct.idCate,
    //     price: widget.detailProduct.pricePro,
    //     images: widget.detailProduct.imgProduct);
    return Container(
      decoration: const BoxDecoration(),
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailProductScreen(product: widget.product)));
        },
        child: Container(
            child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(1, 1))
                  ]),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 150,
                  child: Center(
                      heightFactor: 0.7,
                      child: Image(
                        image: NetworkImage('${widget.product.image}'),
                        fit: BoxFit.fitHeight,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.product.name}',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            color: Colors.teal.shade800),
                      ),
                      Text(widget.product.status == 1 ? 'Còn hàng' : 'Hết hàng',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.product.price}',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          // FavIconListPro(favorites)
                        ],
                      )
                    ],
                  ),
                )
              ])),
        ])),
      ),
    );
  }
}
