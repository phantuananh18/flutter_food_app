class UserModel {
  String? uid;
  String? name;
  String? address;
  String? birth;
  String? gender;
  String? phone;
  String? email;
  String? avatar;

  UserModel(
      {this.uid,
      this.name,
      this.address,
      this.birth,
      this.gender,
      this.phone,
      this.email,
      this.avatar});

  //receive data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        name: map['name'],
        address: map['address'],
        birth: map['birth'],
        gender: map['gender'],
        phone: map['phone'],
        email: map['email'],
        avatar: map['avatar']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'birth': birth,
      'gender': gender,
      'phone': phone,
      'email': email,
      'avatar': avatar
    };
  }

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
        uid: json['uid'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
        birth: json['birth'] as String,
        gender: json['gender'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String);
  }
}
