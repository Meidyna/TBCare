class UserModel {
  final String token;

  UserModel({required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json['data']['token'], // ← ambil dari dalam 'data'
  );
}