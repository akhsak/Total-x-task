class UserModel {
  final String name;
  final int age;
  final String image;

  UserModel({
    required this.name,
    required this.age,
    required this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'image': image,
    };
  }
}
