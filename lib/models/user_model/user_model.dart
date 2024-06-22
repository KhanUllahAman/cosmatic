import 'dart:convert';

UserModel userModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email
  });

  String name;
  String id;
  String email;

factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
  id: json?["id"] ?? "",
  name: json?["name"] ?? "",
  email: json?["email"] ?? "",
);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name":name,
        "email":email  
  };


      UserModel copyWith({
      String? image, name,
    })=>UserModel(
      id: id,
      name: name??this.name, 
      email: email,
    );



}