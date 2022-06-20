class FavoriteModel {
  String? id;
  String? idCustomer;
  int? idProduct;

  FavoriteModel({this.id, this.idCustomer, this.idProduct});

  factory FavoriteModel.fromJson(dynamic json) {
    return FavoriteModel(
        id: json['id'] as String,
        idCustomer: json['id'] as String,
        idProduct: json['idProduct'] as int);
  }
}
