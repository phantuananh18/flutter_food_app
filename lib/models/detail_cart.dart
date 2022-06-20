class DetailCartModel {
  String? id;
  String? idCart;
  int? idProduct;
  int? amount;
  double? total;

  DetailCartModel({this.id, this.idCart, this.idProduct, this.amount, this.total});

  factory DetailCartModel.fromMap(map) {
    return DetailCartModel(
        id: map['id'] as String,
        idCart: map['idCart'] as String,
        idProduct: map['idProduct'] as int,
        amount: map['amount'] as int,
        total: map['total'] as double);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCart': idCart,
      'idProduct': idProduct,
      'amount': amount,
      'total': total,
    };
  }

  factory DetailCartModel.fromJson(dynamic json) {
    return DetailCartModel(
        id: json['id'] as String,
        idCart: json['idCart'] as String,
        idProduct: json['idProduct'] as int,
        amount: json['amount'] as int,
        total: json['total'] as double);
  }
}
