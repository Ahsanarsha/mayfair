import 'dart:convert';
/// success : true
/// data : {"token":"Bearer 49|xH7U4fOMNNk9tmSVg1pDazGnhe8qfN1egG7FmjiX","user_id":5,"name":"waliwali","email":"wali@gmail.com","image":"http://192.168.5.13:8000/assets/images/users/241651259_4291778824271709_5077725150356265875_n.jpg"}
/// message : "user successfully login"

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  UserModel({
      this.success, 
      this.data, 
      this.message,});

  UserModel.fromJson(dynamic json) {
    success = json['success'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? success;
  UserData? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }

}

/// token : "Bearer 49|xH7U4fOMNNk9tmSVg1pDazGnhe8qfN1egG7FmjiX"
/// user_id : 5
/// name : "waliwali"
/// email : "wali@gmail.com"
/// image : "http://192.168.5.13:8000/assets/images/users/241651259_4291778824271709_5077725150356265875_n.jpg"

UserData dataFromJson(String str) => UserData.fromJson(json.decode(str));
String dataToJson(UserData data) => json.encode(data.toJson());
class UserData {
  UserData({
      this.token,
      this.userId,
      this.name,
      this.email,
      this.image,});

  UserData.fromJson(dynamic json) {
    token = json['token'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
  }
  String? token;
  var userId;
  String? name;
  String? email;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['user_id'] = userId;
    map['name'] = name;
    map['email'] = email;
    map['image'] = image;
    return map;
  }

}