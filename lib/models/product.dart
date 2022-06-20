class ProductModel {
  int? id;
  int? idTypeProduct;
  String? name;
  int? price;
  String? description;
  String? image;
  int? status;

  ProductModel(
      {this.id,
      this.idTypeProduct,
      this.name,
      this.price,
      this.description,
      this.image,
      this.status});
  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
        id: json['id'] as int,
        idTypeProduct: json['idTypeProduct'] as int,
        name: json['name'] as String,
        price: json['price'] as int,
        description: json['description'] as String,
        image: json['image'] as String,
        status: json['status'] as int);
  }
}
