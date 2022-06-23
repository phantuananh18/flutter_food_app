class ProductTypeModel {
  int? idCate;
  String? nameCate;
  String? imgCate;

  ProductTypeModel({this.idCate, this.nameCate, this.imgCate});

  factory ProductTypeModel.fromJson(dynamic json) {
    return ProductTypeModel(
        idCate: json['idCate'] as int,
        nameCate: json['nameCate'] as String,
        imgCate: json['imgCate'] as String);
  }
}
