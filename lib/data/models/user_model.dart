class UserModel {
  final String phone;
  final String? name;
  final String? token;

  UserModel({required this.phone, this.name, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'],
      name: json['name'],
      token: json['token'],
    );
  }
}
