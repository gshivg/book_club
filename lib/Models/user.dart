class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    phone = map['phone'];
    address = map['address'];
    image = map['image'];
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
  }

  UserModel toMap() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      image: image,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
