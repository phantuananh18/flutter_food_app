class AddressModel {
  String? id;
  String? name;
  String? phone;
  String? address;
  String? idCustomer;

  AddressModel({this.id, this.name, this.phone, this.address, this.idCustomer});

  //receive data from server
  factory AddressModel.fromMap(map) {
    return AddressModel(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        address: map['address'],
        idCustomer: map['idCustomer']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone, 'address': address, 'idCustomer': idCustomer};
  }

  factory AddressModel.fromJson(dynamic json) {
    return AddressModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String,
        idCustomer: json['idCustomer'] as String);
  }
}
