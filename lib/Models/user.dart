class UserModel {
  String? id;
  String? email;

  String? name;
  String? phone;
  String? address;
  String? image;

  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
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
    createdAt = map['createdAt'].toDate();
    updatedAt = map['updatedAt'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  void updateUserModel({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? image,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.phone = phone ?? this.phone;
    this.address = address ?? this.address;
    this.image = image ?? this.image;
    updatedAt = DateTime.now();
  }
}
