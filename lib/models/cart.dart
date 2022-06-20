class CartModel {
  String? idCart;
  String? idDelivery;
  String? idCustomer;
  String? timeStart;
  String? status;
  String? idVoucher;
  double? sum;

  CartModel(
      {this.idCart,
      this.idDelivery,
      this.idCustomer,
      this.timeStart,
      this.status,
      this.idVoucher,
      this.sum});

  //receive data from server
  factory CartModel.fromMap(map) {
    return CartModel(
        idCart: map['idCart'],
        idDelivery: map['idDelivery'],
        idCustomer: map['idCustomer'],
        timeStart: map['timeStart'],
        status: map['status'],
        idVoucher: map['idVoucher'],
        sum: map['sum']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'idCart': idCart,
      'idDelivery': idDelivery,
      'idCustomer': idCustomer,
      'timeStart': timeStart,
      'status': status,
      'idVoucher': idVoucher
    };
  }

  factory CartModel.fromJson(dynamic json) {
    return CartModel(
        idCart: json['idCart'] as String,
        idDelivery: json['idDelivery'] as String,
        idCustomer: json['idCustomer'] as String,
        timeStart: json['timeStart'] as String,
        status: json['status'] as String,
        idVoucher: json['idVoucher'] as String,
        sum: json['sum'] as double);
  }
}
