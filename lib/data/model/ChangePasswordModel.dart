import 'dart:convert';
/// Status : "Success"
/// message : "Password change successfully"
/// user : {"name":"wali wali","email":"wali@gmail.com"}

ChangePasswordModel changePasswordModelFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));
String changePasswordModelToJson(ChangePasswordModel data) => json.encode(data.toJson());
class ChangePasswordModel {
  ChangePasswordModel({
      this.status, 
      this.message, 
      this.user,});

  ChangePasswordModel.fromJson(dynamic json) {
    status = json['Status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? status;
  String? message;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = status;
    map['message'] = message;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

/// name : "wali wali"
/// email : "wali@gmail.com"

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      this.name, 
      this.email,});

  User.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
  }
  String? name;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    return map;
  }

}